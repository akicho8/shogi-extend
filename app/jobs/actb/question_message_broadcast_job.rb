module Actb
  class QuestionMessageBroadcastJob < ApplicationJob
    queue_as :default

    def perform(message)
      ActionCable.server.broadcast("actb/question_channel/#{message.question_id}", bc_action: :speak_broadcasted, bc_params: {message: render_message(message)})
    end

    private

    def render_message(message)
      # ApplicationController.renderer.render(partial: 'actb/messages/message', locals: { message: message })
      message.as_json(only: [:body], include: {user: {only: [:id, :key, :name], methods: [:avatar_path]}})
    end
  end
end
