# app/javascript/acns1_sample.vue
# app/channels/acns1_sample_channel.rb
# app/models/backend_script/acns1_sample_script.rb
class Acns1SampleChannel < ApplicationCable::Channel
  def subscribed
    stream_from "acns1_sample_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # メッセージをブロードキャストするためのアクション
  def speak(data)
    ActionCable.server.broadcast 'acns1_sample_channel', message: data['message']
  end
end
