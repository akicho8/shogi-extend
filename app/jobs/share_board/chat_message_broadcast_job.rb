module ShareBoard
  class ChatMessageBroadcastJob < ApplicationJob
    queue_as :default

    def perform(room_key, data)
      Room.find_or_create_by!(key: room_key).receive_and_bc(data)
    end
  end
end
