# app/javascript/acns3_sample.vue
# app/channels/acns3_sample_channel.rb
# app/models/backend_script/acns3_sample_script.rb
class Acns3SampleChannel < ApplicationCable::Channel
  def subscribed
    stream_from "acns3_sample_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # メッセージをブロードキャストするためのアクション
  def speak(data)
    ActionCable.server.broadcast 'acns3_sample_channel', message: data['message']
  end
end
