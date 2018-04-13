# モデルに保存する版
class Type022RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "type022_room_channel"
  end

  # なにこれ？
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # モデルに保存して非同期でブロードキャストする
  def type022_say(data)
    if false
      Type022Article.create!(body: data["type022_article_body"])
    else
      type022_article = Type022Article.new(body: data["type022_article_body"], created_at: Time.current)
      # type022_article = Type022Article.create!(body: data["type022_article_body"])

      # body = data["type022_article_body"]
      # type022_article = Type022Article.new {body: body, created_at: Time.current}
      # コントローラーを経由せずに直接ビューを利用してHTMLを作れる
      html = ApplicationController.renderer.render(partial: "resource_ns1/type022_chat_rooms/type022_article", locals: {type022_article: type022_article})

      # それを全員に通知
      # 各自の type022_room.coffee の received メソッドに引数が渡る
      ActionCable.server.broadcast("type022_room_channel", type022_article_html: html)
    end
  end
end
