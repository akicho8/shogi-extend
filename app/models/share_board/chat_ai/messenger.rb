# -*- compile-command: "rails runner 'ShareBoard::ChatAi::Messenger.new.call'" -*-
# どこからでも簡単にチャットに発言する
#
#   rails r 'ShareBoard::ChatAi::Messenger.new.call("こんにちは")'
#
#
module ShareBoard
  module ChatAi
    class Messenger
      attr_accessor :params

      def initialize(params = {})
        @params = {
          :from_user_name => "運営",
          :room_code      => "dev_room",
        }.merge(params)
      end

      def call(message = nil, bc_params = {})
        bc_params = {
          :message      => message || "#{Time.current}",
          :performed_at => Time.current.to_i,
        }.merge(params, bc_params)

        if false
          Broadcaster.new(room_code).call("message_share_broadcasted", bc_params)
        else
          room = Room.find_or_create_by!(key: room_code)
          chot_message = room.chot_messages.create_from_data!(bc_params) # DBに入れる
          chot_message.broadcast_self                                    # バックグラウンドで配る
        end
      end

      private

      def room_code
        params[:room_code]
      end
    end
  end
end
