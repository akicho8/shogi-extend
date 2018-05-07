class SystemNotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "system_notification_channel"

    # このようにすれば SystemNotificationChannel.broadcast_to(chat_user, ...) として個別送信もできる
    stream_for current_chat_user

    current_chat_user.appear
  end

  def unsubscribed
    current_chat_user.disappear
  end

  def message_send_all(data)
    ActionCable.server.broadcast("system_notification_channel", data)
  end
end
