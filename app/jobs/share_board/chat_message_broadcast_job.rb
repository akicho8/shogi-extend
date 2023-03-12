module ShareBoard
  class ChatMessageBroadcastJob < ApplicationJob
    queue_as :default

    def perform(room_code, data)
      # raise [room_code, data].inspect
      # ShareBoard::Messenger.new(room_code, from_user_name: "GPT", message_scope_key: data["message_scope_key"]).call(text)
      # ShareBoard::Messenger.new(room_code, data).call
      # Broadcaster.new(room_code).call("message_share_broadcasted", bc_params)
      ShareBoard::Broadcaster.new(room_code).call("message_share_broadcasted", data)
    end
  end
end
