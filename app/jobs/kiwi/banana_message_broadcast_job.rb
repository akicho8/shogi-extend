module Kiwi
  class BananaMessageBroadcastJob < ApplicationJob
    queue_as :default

    def perform(banana_message)
      ActionCable.server.broadcast("kiwi/banana_room_channel/#{banana_message.banana_id}", bc_action: :speak_broadcasted, bc_params: {banana_message: render_message(banana_message)})
    end

    private

    def render_message(banana_message)
      banana_message.as_json(BananaMessage.json_struct_for_show)
    end
  end
end
