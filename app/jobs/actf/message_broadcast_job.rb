module Actf
  class MessageBroadcastJob < ApplicationJob
    queue_as :default

    def perform(message)
      ActionCable.server.broadcast("actf/room_channel/#{message.room_id}", message: render_message(message))
    end

    private

    def render_message(message)
      # ApplicationController.renderer.render(partial: 'actf/messages/message', locals: { message: message })
      message.as_json(only: [:body], include: {user: {only: [:id, :name], methods: [:avatar_path]}})
    end
  end
end
