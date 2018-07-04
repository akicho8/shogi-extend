class LobbyChannel < ApplicationCable::Channel
  def subscribed
    stream_from "lobby_channel" # ブロードキャストするにはこれが必要
    stream_for current_user
  end

  def unsubscribed
  end

  def chat_say(data)
    current_user.lobby_chat_say(data["message"], msg_options: data["msg_options"])
  end

  def setting_save(data)
    current_user.setting_save(data)
  end

  def matching_start(data)
    current_user.matching_start
  end

  def matching_start_with_robot(data)
    current_user.matching_start_with_robot
  end

  def matching_cancel(data)
    current_user.matching_cancel
  end
end
