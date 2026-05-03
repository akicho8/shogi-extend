# ChatGPTに話の流れを把握させるために使う
#
#  object = ShareBoard::ChatAi::MessageHistory.new(size: 2, expires_in: 1)
#  object.clear_all
#  object.push("a")
#  object.push("b")
#  object.push("c")
#  assert { object.to_a     == ["c", "b"] }
#  object.clear
#  assert { object.to_a.empty? }
#
# ▼指定の部屋の話題確認
# rails r 'puts ShareBoard::ChatAi::MessageHistory.new.to_topic.to_t'
#
# ▼指定の部屋の履歴削除
# rails r 'puts ShareBoard::ChatAi::MessageHistory.new.clear'
#

module ShareBoard
  module ChatAi
    class MessageHistory
      def initialize(options = {})
        @options = {
          :room_key    => "dev_room",
          :size         => 20,       # 保持する件数
          :expires_in   => 1.hours,  # 保持する時間
          :latest_order => false,    # 後から追加したもの順にするか？
        }.merge(options)
      end

      def <<(object)
        push(object)
      end

      def push(*objects) # 引数名を複数形に合わせました
        objects.each do |object|
          redis.multi do |e|
            json_data = object.to_json

            if @options[:latest_order]
              e.call("LPUSH", key, json_data) # ary.unshift(object)
              e.call("LTRIM", key, 0, @options[:size] - 1) # ary = ary.take(size)
            else
              e.call("RPUSH", key, json_data) # ary << object
              e.call("LTRIM", key, -@options[:size], -1) # ary = ary[-size..-1]
            end

            # 寿命を設定（ActiveSupport::Duration を考慮して .to_i）
            e.call("EXPIRE", key, @options[:expires_in].to_i)
          end
        end
      end

      def to_a
        # LRANGE は配列を返す
        rows = redis.call("LRANGE", key, 0, -1)
        rows.collect { |e| JSON.parse(e, symbolize_names: true) }
      end

      def to_topic
        av = to_a.collect { |e| Message.new(e[:role].to_sym, e[:content]) }
        Topic[*av]
      end

      def clear
        redis.call("DEL", key)
      end

      def clear_all
        redis.call("FLUSHDB")
      end

      def redis
        @redis ||= RedisPool.client(AppConfig.fetch(:redis_db_for_share_board_ai))
      end

      def key
        @key ||= Digest::MD5.hexdigest(@options[:room_key])
      end
    end
  end
end
