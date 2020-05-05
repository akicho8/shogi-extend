module Acns3
  class MessageBroadcastJob < ApplicationJob
    queue_as :default

    def perform(message)
      ActionCable.server.broadcast("acns3/room_channel/#{message.room_id}", message: render_message(message))
    end

    private

    def render_message(message)
      ApplicationController.renderer.render(partial: 'acns3/messages/message', locals: { message: message })
    end
  end
end
