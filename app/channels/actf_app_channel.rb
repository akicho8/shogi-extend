# app/javascript/actf_app.vue
# app/channels/actf_app_channel.rb
# app/models/backend_script/actf_app_script.rb
class ActfSampleChannel < ApplicationCable::Channel
  def subscribed
    stream_from "actf_app_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # メッセージをブロードキャストするためのアクション
  def speak(data)
    ActionCable.server.broadcast 'actf_app_channel', message: data['message']
  end
end
