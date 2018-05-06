# チャットルーム一覧
class LobbyChannel < ApplicationCable::Channel
  def subscribed
    stream_from "lobby_channel" # ブロードキャストするにはこれが必要
    stream_for current_chat_user
  end

  def unsubscribed
  end

  def matching_start(data)
    # 前回のルールを保存
    current_chat_user.update!({
        lifetime_key: data["lifetime_key"],
        ps_preset_key: data["ps_preset_key"],
        po_preset_key: data["po_preset_key"],
      })

    s = ChatUser.all
    s = s.where.not(online_at: nil)                             # オンラインの人のみ
    s = s.where.not(id: current_chat_user.id)                   # 自分以外
    s = s.where.not(matching_at: nil)                           # マッチング希望者
    s = s.where(lifetime_key: current_chat_user.lifetime_key)   # 同じ持ち時間
    s = s.where(ps_preset_key: current_chat_user.po_preset_key) # 「相手から見た自分」と「相手」の手合が一致する
    s = s.where(po_preset_key: current_chat_user.ps_preset_key) # 「相手から見た相手」と「自分」の手合が一致する

    if s.count == 0
      # 誰もいないので登録する
      current_chat_user.update!(matching_at: Time.current)
      LobbyChannel.broadcast_to(current_chat_user, matching_wait: true)
      return
    end

    opponent = s.sample
    opponent.update!(matching_at: nil) # 相手のマッチング状態を解除

    users = [current_chat_user, opponent]
    if users.all? { |e| e.ps_preset_key == "平手" }
      users = users.shuffle
    else
      users = users.sort_by { |e| (e.ps_preset_key == "平手") ? 0 : 1 }
    end

    chat_room = opponent.owner_rooms.create!(chat_users: users)
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
