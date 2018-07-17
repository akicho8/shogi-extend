class ChatMessageBroadcastJob < ApplicationJob
  queue_as :default

  # 全員に通知
  def perform(chat_message)
    # ActionCable.server.broadcast("battle_channel", message: render_html(chat_message))
  end

  private

  # HTMLを作る
  def render_html(chat_message)
    ApplicationController.renderer.render(partial: "colosseum/battles/chat_message", locals: {chat_message: chat_message})
  end
end
