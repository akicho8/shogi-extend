class ChatMessageBroadcastJob < ApplicationJob
  queue_as :default

  # 全員に通知
  def perform(chat_message)
    # ActionCable.server.broadcast("battle_room_channel", message: render_html(chat_message))
  end

  private

  # HTMLを作る
  def render_html(chat_message)
    ApplicationController.renderer.render(partial: "resource_ns1/swars/battle_rooms/chat_message", locals: {chat_message: chat_message})
  end
end
