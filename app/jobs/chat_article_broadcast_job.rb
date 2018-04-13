class ChatArticleBroadcastJob < ApplicationJob
  queue_as :default

  # 全員に通知
  def perform(chat_article)
    # ActionCable.server.broadcast("chat_room_channel", chat_article_body: render_html(chat_article))
  end

  private

  # HTMLを作る
  def render_html(chat_article)
    ApplicationController.renderer.render(partial: "resource_ns1/chat_rooms/chat_article", locals: {chat_article: chat_article})
  end
end
