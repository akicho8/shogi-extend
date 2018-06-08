class RoomChatMessageBroadcastJob < ApplicationJob
  queue_as :default

  # 全員に通知
  def perform(room_chat_message)
    # ActionCable.server.broadcast("battle_room_channel", message: render_html(room_chat_message))
  end

  private

  # HTMLを作る
  def render_html(room_chat_message)
    ApplicationController.renderer.render(partial: "resource_ns1/battle_rooms/room_chat_message", locals: {room_chat_message: room_chat_message})
  end
end
