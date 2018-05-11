# モデルに保存する版
class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from room_key
    stream_for current_chat_user
  end

  def unsubscribed
    # js 側では無理でも ruby 側だと接続切れの処理が書ける
    room_out({})
  end

  # /Users/ikeda/src/shogi_web/app/javascript/packs/chat_room.js の App.chat_room.send({kifu_body_sfen: response.data.sfen}) で呼ばれる
  # アクションを指定せずに send で呼ぶときに対応する Rails 側のアクションらしい
  # が、ごちゃごちゃになりそうなので使わない
  def receive(data)
  end

  ################################################################################

  # # 定期的に観戦者を更新する
  # def watch_users_update_by_polling(data)
  #   ChatRoomChannel.broadcast_to(current_chat_user, watch_users: current_chat_room.watch_users)
  # end

  # 発言
  def chat_say(data)
    room_chat_message = current_chat_user.room_chat_messages.create!(chat_room: current_chat_room, message: data["message"])
    ActionCable.server.broadcast(room_key, room_chat_message: room_chat_message.js_attributes)
  end

  # わざわざ ruby 側に戻してブロードキャストする意味がない気がする
  # JavaScript 側でそのまま自分以外にブロードキャストできればそれにこしたことはない → たぶん方法はある
  def kifu_body_sfen_broadcast(data)
    ActionCable.server.broadcast(room_key, data)
  end

  # def preset_key_update(data)
  #   preset_info = Warabi::PresetInfo.fetch(data["preset_key"])
  #   current_chat_room.update!(preset_key: preset_info.key)
  #
  #   ActionCable.server.broadcast(room_key, current_chat_room.js_attributes)
  # end

  def lifetime_key_update(data)
    lifetime_info = LifetimeInfo.fetch(data["lifetime_key"])
    current_chat_room.update!(lifetime_key: lifetime_info.key)

    ActionCable.server.broadcast(room_key, data)
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
    # unless current_chat_room.chat_users.include?(current_chat_user)
    #   current_chat_room.chat_users << current_chat_user
    # end

    if current_chat_memberships.present?
      # 対局者
      current_chat_memberships.each do |e|
        e.update!(fighting_now_at: Time.current)
      end
    else
      # 観戦者
      unless current_chat_room.watch_users.include?(current_chat_user)
        current_chat_room.watch_users << current_chat_user
        current_chat_room.broadcast # counter_cache の watch_memberships_count を反映させるため
      end
    end

    if current_chat_room.battle_end_at
    else
      # 自分が対局者の場合
      if current_chat_memberships.present?
        current_chat_memberships.each do |e|
          unless e.standby_at
            e.update!(standby_at: Time.current)
          end
        end
        if current_chat_room.chat_memberships.standby_enable.count >= current_chat_room.chat_memberships.count
          game_start({})
        end
      end
    end

    room_members_update
  end

  def room_out(data)
    chat_say("message" => '<span class="has-text-info">退室しました</span>')

    current_chat_user.update!(current_chat_room_id: nil)

    if current_chat_memberships.present?
      # 対局者
      # 切断したときにの処理がここで書ける
      # TODO: 対局中なら、残っている方がポーリングを開始して、10秒間以内に戻らなかったら勝ちとしてあげる
      current_chat_memberships.each do |e|
        e.update!(fighting_now_at: nil)
      end
    else
      # 観戦者
      current_chat_room.watch_users.destroy(current_chat_user)
      # ActionCable.server.broadcast(room_key, watch_users: current_chat_room.watch_users)
    end

    room_members_update
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
    room_members_update
  end

  private

  def room_members_update
    # model の中から行う
    ActionCable.server.broadcast(room_key, room_members: current_chat_room.reload.js_room_members) # 部屋を抜けたときの状態が反映されるように reload が必要
  end

  def room_key
    "chat_room_channel_#{params[:chat_room_id]}"
  end

  def current_chat_room
    @current_chat_room ||= ChatRoom.find(params[:chat_room_id])
  end

  # 自分対自分の場合もあるためメンバー情報は複数ある
  def current_chat_memberships
    @current_chat_memberships ||= current_chat_room.chat_memberships.where(chat_user: current_chat_user)
  end
end
