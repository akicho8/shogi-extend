# モデルに保存する版
class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    # ChatMembership.destroy_all

    Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, "subscribed", params])

    # stream_from "chat_#{params[:room]}"
    # Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, params[:chat_room_id]])

    # stream_from [:chat_room_channel, params[:chat_room_id]].join
    stream_from room_key

    # post = Post.find(params[:id])
    # stream_for post
    # ChatRoomChannel.broadcast_to(@post, @comment)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__])
  end

  # /Users/ikeda/src/shogi_web/app/javascript/packs/chat_room.js の App.chat_room.send({kifu_body_sfen: response.data.sfen}) で呼ばれる
  def receive(data)
    Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__])
    # if data["kifu_body_sfen"]
    #   Rails.logger.debug(current_chat_user)
    #   ActionCable.server.broadcast(room_key, data)
    # end
  end

  ################################################################################

  # モデルに保存して非同期でブロードキャストする
  def chat_say(data)
    if false
      ChatArticle.create!(message: data["chat_article_body"])
    else
      chat_user = ChatUser.find(data["sayed_chat_user_id"])
      chat_room = ChatRoom.find(data["chat_room_id"])
      chat_article = chat_user.chat_articles.create!(chat_room: chat_room, message: data["chat_article_body"])
      # chat_article = ChatArticle.create!(body: data["chat_article_body"])

      # body = data["chat_article_body"]
      # chat_article = ChatArticle.new {body: body, created_at: Time.current}
      # コントローラーを経由せずに直接ビューを利用してHTMLを作れる
      # html = ApplicationController.renderer.render(partial: "resource_ns1/chat_rooms/chat_article", locals: {chat_article: chat_article})

      # それを全員に通知
      # 各自の chat_room.js の received メソッドに引数が渡る
      attributes = chat_article.attributes.merge(chat_user: chat_article.chat_user.attributes, chat_room: chat_article.chat_room.attributes)
      ActionCable.server.broadcast(room_key, chat_article: attributes)
    end
  end

  # わざわざ ruby 側に戻してブロードキャストする意味がない気がする
  # JavaScript 側でそのまま自分以外にブロードキャストできればそれにこしたことはない → たぶん方法はある
  def kifu_body_sfen_broadcast(data)
    ActionCable.server.broadcast(room_key, data)
  end

  def preset_key_broadcast(data)
    preset_info = Warabi::PresetInfo.fetch(data["preset_key"])
    current_chat_room.update!(preset_key: preset_info.key)

    ActionCable.server.broadcast(room_key, current_chat_room.js_attributes)
  end

  def member_location_change_broadcast(data)
    # App.chat_room.member_location_change_broadcast({chat_membership_id: chat_membership_id, location_key: location_key})
    chat_membership_id = data["chat_membership_id"]
    location_key = data["location_key"]
    
    chat_membership = current_chat_room.chat_memberships.find(chat_membership_id)
    chat_membership.location_key = location_key
    chat_membership.save!
    
    # online_members = data["online_members"]
    # online_members.each do |e|
    #   if chat_membership = current_chat_room.chat_memberships.find_by(chat_user_id: e["chat_user_id"])
    #     chat_membership.location_key = e["location_key"]
    #     chat_membership.save!
    #   end
    # end
    ActionCable.server.broadcast(room_key, online_members: JSON.load(current_chat_room.chat_memberships.reload.to_json(include: [:chat_user])))
    # ActionCable.server.broadcast(room_key, online_members: JSON.load(current_chat_room.chat_memberships.reload.to_json(include: [:chat_user])), without_id: current_chat_user.id)
  end

  def room_name_changed(data)
    chat_room = ChatRoom.find(params[:chat_room_id])
    chat_room.update!(name: data["room_name"])
    ActionCable.server.broadcast(room_key, data)
  end

  def room_in(data)
    current_chat_user.update!(current_chat_room: current_chat_room)
    unless current_chat_room.chat_users.include?(current_chat_user)
      current_chat_room.chat_users << current_chat_user
    end
    online_members_update
  end

  def room_out(data)
    current_chat_user.update!(current_chat_room_id: nil)
    
    current_chat_room.chat_users.destroy(current_chat_user)

    online_members_update
  end
  
  def game_start(data)
    current_chat_room.update!(game_started_at: Time.current)
    ActionCable.server.broadcast(room_key, game_started_at: current_chat_room.game_started_at)
  end

  private

  def online_members_update
    ActionCable.server.broadcast(room_key, online_members: JSON.load(current_chat_room.chat_memberships.reload.to_json(include: [:chat_user])))
  end

  def room_key
    "chat_room_channel_#{params[:chat_room_id]}"
  end

  def current_chat_room
    @current_chat_room ||= ChatRoom.find(params[:chat_room_id])
  end
end
