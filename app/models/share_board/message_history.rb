# ChatGPTに話の流れを把握させるために使う
#
#  object = ShareBoard::MessageHistory.new(size: 2, expires_in: 1)
#  object.clear_all
#  object.push("a")
#  object.push("b")
#  object.push("c")
#  assert { object.to_a     == ["c", "b"] }
#  object.clear
#  assert { object.to_a.empty? }
#
# ▼指定の部屋の話題確認
# rails r 'puts ShareBoard::MessageHistory.new.to_topic.to_t'
#
# ▼指定の部屋の履歴削除
# rails r 'puts ShareBoard::MessageHistory.new.clear'
#
module ShareBoard
  class MessageHistory
    def initialize(options = {})
      @options = {
        :room_code    => "dev_room",
        :size         => 20,       # 保持する件数
        :expires_in   => 1.hours,  # 保持する時間
        :latest_order => false,    # 後から追加したもの順にするか？
      }.merge(options)
    end

    def <<(object)
      push(object)
    end

    def push(*object)
      object.each do |object|
        redis.multi do |e|
          if @options[:latest_order]
            e.lpush(key, object.to_json)         # ary.unshift(object)
            e.ltrim(key, 0, @options[:size] - 1) # ary = ary.take(size)
          else
            e.rpush(key, object.to_json)         # ary << object
            e.ltrim(key, -@options[:size], -1)   # ary = ary[-size..-1]
          end
          e.expire(key, @options[:expires_in])   # ary の寿命 = expires_in
        end
      end
    end

    def to_a
      redis.lrange(key, 0, -1).collect { |e| JSON.parse(e, symbolize_names: true) }
    end

    def to_topic
      av = to_a.collect { |e| Message.new(e[:role].to_sym, e[:content]) }
      Topic[*av]
    end

    def clear
      redis.del(key)
    end

    def clear_all
      redis.flushdb
    end

    def redis
      @redis ||= Redis.new(db: AppConfig.fetch(:redis_db_for_share_board_gpt))
    end

    def key
      @key ||= Digest::MD5.hexdigest(@options[:room_code])
    end
  end
end
