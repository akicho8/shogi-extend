# モデルに保存する版
class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from room_key
  end

  def unsubscribed
  end

  # /Users/ikeda/src/shogi_web/app/javascript/packs/chat_room.js の App.chat_room.send({kifu_body_sfen: response.data.sfen}) で呼ばれる
  # アクションを指定せずに send で呼ぶときに対応する Rails 側のアクションらしい
  # が、ごちゃごちゃになりそうなので使わない
  def receive(data)
  end

  ################################################################################

  # 発言
  def chat_say(data)
    chat_article = current_chat_user.chat_articles.create!(chat_room: current_chat_room, message: data["chat_message_body"])
    ActionCable.server.broadcast(room_key, chat_article: chat_article.js_attributes)
  end

  # わざわざ ruby 側に戻してブロードキャストする意味がない気がする
  # JavaScript 側でそのまま自分以外にブロードキャストできればそれにこしたことはない → たぶん方法はある
  def kifu_body_sfen_broadcast(data)
    ActionCable.server.broadcast(room_key, data)
  end

  def preset_key_update(data)
    preset_info = Warabi::PresetInfo.fetch(data["preset_key"])
    current_chat_room.update!(preset_key: preset_info.key)

    ActionCable.server.broadcast(room_key, current_chat_room.js_attributes)
  end

  def lifetime_key_update(data)
    lifetime_info = LifetimeInfo.fetch(data["lifetime_key"])
    current_chat_room.update!(lifetime_key: lifetime_info.key)

    ActionCable.server.broadcast(room_key, data)
  end

  def member_location_change(data)
    # App.chat_room.member_location_change({chat_membership_id: chat_membership_id, location_key: location_key})
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
    current_chat_room.update!(name: data["room_name"])
    ActionCable.server.broadcast(room_key, data)
  end

  def room_in(data)
    # 自分から部屋に入ったらマッチングを解除する
    current_chat_user.update!(matching_at: nil)

    # どの部屋にいるか設定
    current_chat_user.update!(current_chat_room: current_chat_room)

    # 部屋のメンバーとして登録
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
    current_chat_room.update!(battle_started_at: Time.current)
    ActionCable.server.broadcast(room_key, battle_started_at: current_chat_room.battle_started_at)
  end

  def timeout_game_end(data)
    current_chat_room.update!(battle_ended_at: Time.current, win_location_key: data["win_location_key"])
    ActionCable.server.broadcast(room_key, battle_ended_at: current_chat_room.battle_ended_at, win_location_key: current_chat_room.win_location_key)
  end

  def give_up_game_end(data)
    current_chat_room.update!(battle_ended_at: Time.current, win_location_key: data["win_location_key"], give_up_location_key: data["give_up_location_key"])
    ActionCable.server.broadcast(room_key, battle_ended_at: current_chat_room.battle_ended_at, win_location_key: current_chat_room.win_location_key, give_up_location_key: current_chat_room.give_up_location_key)
  end

  # 先後をまとめて反転する
  def location_flip_all(data)
    current_chat_room.chat_memberships.each(&:location_flip!)
    online_members_update
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
