# app/javascript/xclock_app/application.vue
# app/channels/xclock_app_channel.rb
# app/models/backend_script/xclock_app_script.rb
class XclockAppChannel < ApplicationCable::Channel
  def subscribed
    stream_from "xclock_app_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # メッセージをブロードキャストするためのアクション
  def speak(data)
    ActionCable.server.broadcast 'xclock_app_channel', message: data['message']
  end
end
