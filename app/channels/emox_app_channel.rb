# app/javascript/emox_app/application.vue
# app/channels/emox_app_channel.rb
# app/models/backend_script/emox_app_script.rb
class EmoxAppChannel < ApplicationCable::Channel
  def subscribed
    stream_from "emox_app_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # メッセージをブロードキャストするためのアクション
  def speak(data)
    ActionCable.server.broadcast 'emox_app_channel', message: data['message']
  end
end
