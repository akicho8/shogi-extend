class SystemNotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "system_notification_channel"
    current_chat_user.appear
    # stream_for current_chat_user
  end

  def unsubscribed
    logger.debug(["#{__FILE__}:#{__LINE__}", __method__, ])
    current_chat_user.disappear
  end

  def message_send_all(data)
    ActionCable.server.broadcast("system_notification_channel", data)
  end
end
