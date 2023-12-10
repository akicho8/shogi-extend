module ShareBoard
  class ChatMessageBroadcastJob < ApplicationJob
    queue_as :default

    def perform(room_code, data)
      Room.find_or_create_by!(key: room_code).receive_and_bc(data)
    end
  end
end
