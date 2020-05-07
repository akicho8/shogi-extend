# app/javascript/acns3_app.vue
# app/channels/acns3_app_channel.rb
# app/models/backend_script/acns3_app_script.rb
class Acns3SampleChannel < ApplicationCable::Channel
  def subscribed
    stream_from "acns3_app_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # メッセージをブロードキャストするためのアクション
  def speak(data)
    ActionCable.server.broadcast 'acns3_app_channel', message: data['message']
  end
end
