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

    online_members_update
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

    # 部屋のメンバーとして登録(マッチング済みの場合はもう登録されている)
    unless current_chat_room.chat_users.include?(current_chat_user)
      current_chat_room.chat_users << current_chat_user
    end

    unless current_chat_room.battle_end_at
      # 中間情報
      if current_chat_membership
        # 自分が対局者の場合
        if current_chat_membership.location_key
          unless current_chat_membership.standby_at
            current_chat_membership.update!(standby_at: Time.current)
            if current_chat_room.chat_memberships.standby_enable.count >= Warabi::Location.count
              game_start({})
            end
          end
        end
      end
    end

    online_members_update
  end

  # FIXME: これ呼ばれているか確認
  def room_out(data)
    current_chat_user.update!(current_chat_room_id: nil)

    # 必ずある
    if chat_membership = current_chat_room.chat_memberships.find_by(chat_user: current_chat_user)
      # 観戦者の場合のみ退出扱いとする
      unless chat_membership.location_key
        chat_membership.destroy!
      end
      # current_chat_room.chat_users.destroy(current_chat_user)
    end

    online_members_update
  end

  def game_start(data)
    current_chat_room.update!(battle_begin_at: Time.current)
    ActionCable.server.broadcast(room_key, battle_begin_at: current_chat_room.battle_begin_at)
  end

  def timeout_game_end(data)
    if current_chat_room.battle_end_at
      # みんなで送信してくるので1回だけに絞るため
      return
    end
    current_chat_room.update!(battle_end_at: Time.current, win_location_key: data["win_location_key"])
    ActionCable.server.broadcast(room_key, battle_end_at: current_chat_room.battle_end_at, win_location_key: current_chat_room.win_location_key)
  end

  def give_up_game_end(data)
    current_chat_room.update!(battle_end_at: Time.current, win_location_key: data["win_location_key"], give_up_location_key: data["give_up_location_key"])
    ActionCable.server.broadcast(room_key, battle_end_at: current_chat_room.battle_end_at, win_location_key: current_chat_room.win_location_key, give_up_location_key: current_chat_room.give_up_location_key)
  end

  # 先後をまとめて反転する
  def location_flip_all(data)
    current_chat_room.chat_memberships.each(&:location_flip!)
    online_members_update
  end

  private

  def online_members_update
    ActionCable.server.broadcast(room_key, room_members: current_chat_room.js_room_members)
  end

  def room_key
    "chat_room_channel_#{params[:chat_room_id]}"
  end

  def current_chat_room
    @current_chat_room ||= ChatRoom.find(params[:chat_room_id])
  end

  def current_chat_membership
    @current_chat_membership ||= current_chat_room.chat_memberships.find_by(chat_user: current_chat_user)
  end
end
