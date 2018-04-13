class Type022ArticleBroadcastJob < ApplicationJob
  queue_as :default

  # 全員に通知
  def perform(type022_article)
    ActionCable.server.broadcast("type022_room_channel", type022_article_body: render_html(type022_article))
  end

  private

  # HTMLを作る
  def render_html(type022_article)
    ApplicationController.renderer.render(partial: "resource_ns1/type022_chat_rooms/type022_article", locals: {type022_article: type022_article})
  end
end
