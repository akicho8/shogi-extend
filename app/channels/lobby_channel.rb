# チャットルーム一覧
class LobbyChannel < ApplicationCable::Channel
  def subscribed
    stream_from "lobby_channel" # ブロードキャストするにはこれが必要
    stream_for current_chat_user
    current_chat_user.update!(current_chat_room_id: nil)
  end

  def unsubscribed

    # logger.debug(["#{__FILE__}:#{__LINE__}", __method__, ])
    # current_chat_user.disappear
  end

  # def appear(data)
  #   logger.debug(["#{__FILE__}:#{__LINE__}", __method__, data])
  #   # current_chat_user.appear on: data['appearing_at']
  #   current_chat_user.update!(appearing_at: Time.current)
  # end
  #
  # def away
  #   logger.debug(["#{__FILE__}:#{__LINE__}", __method__, ])
  #   # current_chat_user.away
  # end

  def matching_start(data)
    if true
      # 前回のルールを保存
      current_chat_user.update!({
          lifetime_key: data["lifetime_key"],
          preset_key: data["preset_key"],
        })
    end

    s = ChatUser.all
    s = s.where.not(id: current_chat_user.id)       # 自分以外
    s = s.where.not(matching_at: nil)               # マッチング希望者
    s = s.where(lifetime_key: data["lifetime_key"]) # 同じ持ち時間
    s = s.where(preset_key: data["preset_key"])     # 同じ手合割希望者

    if s.count == 0
      # 誰もいないので登録する
      current_chat_user.update!({
          matching_at: Time.current,
          lifetime_key: data["lifetime_key"],
          preset_key: data["preset_key"],
        })

      LobbyChannel.broadcast_to(current_chat_user, matching_wait: true)
      return
    end

    opponent = s.sample
    opponent.update!(matching_at: nil) # 相手のマッチング状態を解除

    users = [current_chat_user, opponent]
    if users.all? { |e| e.preset_key == "平手" }
      users = users.shuffle
    else
      users = users.sort_by { |e| (e.preset_key == "平手") ? 0 : 1 }
    end

    chat_room = opponent.owner_rooms.create!
    chat_room.chat_users = users
    chat_room.update!(auto_matched_at: Time.current)
    # chat_room.update!(battle_begin_at: Time.current) # バトル開始

    chat_room.chat_users.each do |chat_user|
      ActionCable.server.broadcast("single_notification_#{chat_user.id}", {
          matching_ok: true,
          chat_room: chat_room.js_attributes,
        })
    end
  end

  def matching_cancel(data)
    current_chat_user.update!(matching_at: nil)
  end
end
