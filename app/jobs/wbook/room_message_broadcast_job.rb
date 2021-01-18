module Wbook
  class RoomMessageBroadcastJob < ApplicationJob
    queue_as :default

    def perform(message)
      ActionCable.server.broadcast("wbook/room_channel/#{message.room_id}", bc_action: :room_speak_broadcasted, bc_params: {message: render_message(message)})
    end

    private

    def render_message(message)
      # ApplicationController.renderer.render(partial: 'wbook/messages/message', locals: { message: message })
      message.as_json_type8
    end
  end
end
