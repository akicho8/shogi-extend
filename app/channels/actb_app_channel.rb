# app/javascript/actb_app/application.vue
# app/channels/actb_app_channel.rb
# app/models/backend_script/actb_app_script.rb
class ActbSampleChannel < ApplicationCable::Channel
  def subscribed
    stream_from "actb_app_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # メッセージをブロードキャストするためのアクション
  def speak(data)
    ActionCable.server.broadcast 'actb_app_channel', message: data['message']
  end
end
