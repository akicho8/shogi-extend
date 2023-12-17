# -*- compile-command: "rails runner 'ShareBoard::ChatAi::Messenger.new.call'" -*-
# どこからでも簡単にチャットに発言する
#
#   rails r 'ShareBoard::ChatAi::Messenger.new.call("こんにちは")'
#
module ShareBoard
  module ChatAi
    class Messenger
      DIRECT_MODE = false

      attr_accessor :params

      def initialize(params = {})
        @params = {
          :from_user_name => "運営",
          :room_key      => "dev_room",
        }.merge(params)
      end

      def call(content = nil, bc_params = {})
        bc_params = {
          :content      => content || "#{Time.current}",
          :performed_at => Time.current.to_f * 1000,
        }.merge(params, bc_params)

        if DIRECT_MODE
          Broadcaster.new(room_key).call("message_share_broadcasted", bc_params)
        else
          chat_message = room.chat_messages.create_from_data!(bc_params) # DBに入れる
          chat_message.broadcast_to_all                                  # バックグラウンドで配る
        end
      end

      private

      def room
        Room.find_or_create_by!(key: room_key)
      end

      def room_key
        params[:room_key]
      end
    end
  end
end
