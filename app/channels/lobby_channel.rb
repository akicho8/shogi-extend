# チャットルーム一覧
class LobbyChannel < ApplicationCable::Channel
  def subscribed
    stream_from "lobby_channel" # ブロードキャストするにはこれが必要
    stream_for current_chat_user
  end

  def unsubscribed
  end

  def chat_say(data)
    lobby_chat_message = current_chat_user.lobby_chat_messages.create!(message: data["message"])
    ActionCable.server.broadcast("lobby_channel", lobby_chat_message: lobby_chat_message.as_json)
  end

  def setting_save(data)
    current_chat_user.update!({
        lifetime_key: data["lifetime_key"],
        ps_preset_key: data["ps_preset_key"],
        po_preset_key: data["po_preset_key"],
      })
  end

  def matching_start(data)
    current_chat_user.matching_start
  end

  def matching_cancel(data)
    current_chat_user.update!(matching_at: nil)
  end
end
