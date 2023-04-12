# 全部これで送る

# ▼メッセージ送信
# rails r 'ShareBoard::Broadcaster.new.call("message_share_broadcasted", message: "OK")'
# rails r 'ShareBoard::Broadcaster.new.call("message_share_broadcasted", message: "OK", from_user_name: "運営")'

module ShareBoard
  class Broadcaster
    attr_accessor :room_code
    attr_accessor :default_params

    def initialize(room_code = "dev_room", default_params = {})
      @room_code = room_code
      @default_params = {
        :API_VERSION => ShareBoardControllerMethods::API_VERSION,
      }.merge(default_params)
    end

    def call(bc_action, bc_params = {})
      bc_params = default_params.merge(bc_params)
      validate!(bc_params)
      ActionCable.server.broadcast(broadcast_to, {bc_action: bc_action, bc_params: bc_params})
    end

    private

    def validate!(bc_params)
      if v = bc_params.find_all { |k, v| v.nil? }.presence
        v = v.to_h.except(*Array(bc_params["__nil_check_skip_keys__"]))
        if v.present?
          raise ArgumentError, "値が nil のキーがある : #{v.inspect}"
        end
      end
    end

    def broadcast_to
      "share_board/room_channel/#{room_code}"
    end
  end
end
