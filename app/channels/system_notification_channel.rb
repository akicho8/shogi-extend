class SystemNotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "system_notification_channel"

    if current_user
      # このようにすれば SystemNotificationChannel.broadcast_to(user, ...) として個別送信もできる
      stream_for current_user
      current_user.appear
    end
  end

  def unsubscribed
    if current_user
      # FIXME: 接続中であってもこれが頻繁に呼ばれる
      # システムテストのときもここが呼ばれるのでログインユーザーがオフラインと見なされてしまうことがある

      # テストのときも転けるのでオフラインにしない
      if Rails.env.test?
        # p ["#{__FILE__}:#{__LINE__}", __method__, "切断"]
        return
      end

      current_user.disappear
    end
  end

  def message_send_all(data)
    ActionCable.server.broadcast("system_notification_channel", data)
  end
end
