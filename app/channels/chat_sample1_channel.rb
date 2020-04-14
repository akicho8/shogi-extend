# app/javascript/chat_sample1.vue
# app/channels/chat_sample1_channel.rb
# app/models/backend_script/chat_sample1_script.rb
class ChatSample1Channel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_sample1_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # メッセージをブロードキャストするためのアクション
  def speak(data)
    ActionCable.server.broadcast 'chat_sample1_channel', message: data['message']
  end
end
