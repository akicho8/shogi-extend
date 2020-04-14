# app/javascript/acns2_sample.vue
# app/channels/acns2_sample_channel.rb
# app/models/backend_script/acns2_sample_script.rb
class Acns2SampleChannel < ApplicationCable::Channel
  def subscribed
    stream_from "acns2_sample_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # メッセージをブロードキャストするためのアクション
  def speak(data)
    ActionCable.server.broadcast 'acns2_sample_channel', message: data['message']
  end
end
