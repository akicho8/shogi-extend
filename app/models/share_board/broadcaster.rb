# 全部これで送る

# ▼メッセージ送信
# rails r 'ShareBoard::Broadcaster.new.call("message_share_broadcasted", content: "OK")'
# rails r 'ShareBoard::Broadcaster.new.call("message_share_broadcasted", content: "OK", from_user_name: "運営", primary_emoji: "🤖")'

module ShareBoard
  class Broadcaster
    attr_accessor :room_key
    attr_accessor :default_params

    def initialize(room_key = nil, default_params = {})
      @room_key = room_key || "dev_room"
      @default_params = {
        :SERVER_SIDE_API_VERSION => AppConfig[:share_board_api_version],
      }.merge(default_params)
    end

    def call(bc_action, bc_params = {})
      bc_params = default_params.merge(bc_params)
      validate!(bc_params)
      ActionCable.server.broadcast(broadcast_to, { bc_action: bc_action, bc_params: bc_params })
    end

    private

    def validate!(bc_params)
      if v = bc_params.find_all { |k, v| v.nil? }.presence
        Rails.logger.debug { ["#{__FILE__}:#{__LINE__}", __method__, bc_params] }
        v = v.to_h.except(*Array(bc_params["__nil_check_skip_keys__"]))
        if v.present?
          raise ArgumentError, "値が nil のキーがある : #{v.inspect}"
        end
      end
    end

    def broadcast_to
      "share_board/room_channel/#{room_key}"
    end
  end
end
