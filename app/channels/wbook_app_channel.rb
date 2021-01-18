# app/javascript/wbook_app/application.vue
# app/channels/wbook_app_channel.rb
# app/models/backend_script/wbook_app_script.rb
class WbookAppChannel < ApplicationCable::Channel
  def subscribed
    stream_from "wbook_app_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # メッセージをブロードキャストするためのアクション
  def speak(data)
    ActionCable.server.broadcast 'wbook_app_channel', message: data['message']
  end
end
