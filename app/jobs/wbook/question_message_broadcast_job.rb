module Wbook
  class QuestionMessageBroadcastJob < ApplicationJob
    queue_as :default

    def perform(message)
      ActionCable.server.broadcast("wbook/question_channel/#{message.question_id}", bc_action: :speak_broadcasted, bc_params: {message: render_message(message)})
    end

    private

    def render_message(message)
      # ApplicationController.renderer.render(partial: 'wbook/messages/message', locals: { message: message })
      message.as_json_type8
    end
  end
end
