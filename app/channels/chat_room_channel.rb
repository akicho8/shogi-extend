# モデルに保存する版
class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, "subscribed"])
    stream_from "chat_room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, "unsubscribed"])
  end

  # モデルに保存して非同期でブロードキャストする
  def chat_say(data)
    if false
      ChatArticle.create!(body: data["chat_article_body"])
    else
      chat_article = ChatArticle.create!(body: data["chat_article_body"])
      # chat_article = ChatArticle.create!(body: data["chat_article_body"])

      # body = data["chat_article_body"]
      # chat_article = ChatArticle.new {body: body, created_at: Time.current}
      # コントローラーを経由せずに直接ビューを利用してHTMLを作れる
      # html = ApplicationController.renderer.render(partial: "resource_ns1/chat_rooms/chat_article", locals: {chat_article: chat_article})

      # それを全員に通知
      # 各自の chat_room.coffee の received メソッドに引数が渡る
      ActionCable.server.broadcast("chat_room_channel", chat_article: chat_article)
    end
  end
end
