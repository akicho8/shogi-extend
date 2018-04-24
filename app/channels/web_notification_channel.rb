class WebNotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "web_notification_#{current_chat_user.id}"
  end

  def message_send_to(data)
    ActionCable.server.broadcast("web_notification_#{data['to']['id']}", data)
  end
end
