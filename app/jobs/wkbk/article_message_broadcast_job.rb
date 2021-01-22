module Wkbk
  class ArticleMessageBroadcastJob < ApplicationJob
    queue_as :default

    def perform(message)
      ActionCable.server.broadcast("wkbk/article_channel/#{message.article_id}", bc_action: :speak_broadcasted, bc_params: {message: render_message(message)})
    end

    private

    def render_message(message)
      # ApplicationController.renderer.render(partial: 'wkbk/messages/message', locals: { message: message })
      message.as_json_type8
    end
  end
end
