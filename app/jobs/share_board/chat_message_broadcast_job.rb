module ShareBoard
  class ChatMessageBroadcastJob < ApplicationJob
    queue_as :default

    def perform(room_code, data)
      ShareBoard::Broadcaster.new(room_code).call("message_share_broadcasted", data)
    end
  end
end
