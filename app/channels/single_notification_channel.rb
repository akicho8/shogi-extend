class SingleNotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "single_notification_#{current_chat_user.id}"
  end

  def message_send_to(data)
    ActionCable.server.broadcast("single_notification_#{data['to']['id']}", data)
  end

  def battle_request_to(data)
    e = data["battle_request"]
    ActionCable.server.broadcast("single_notification_#{e['to']['id']}", data)
  end

  def battle_match_ok(data)
    e = data["battle_request"]
    alice = ChatUser.find(e["from"]["id"]) # 最初にリクエストを送った方
    bob = ChatUser.find(e["to"]["id"])     # 承諾した方
    alice.battle_match_to(bob, chat_room: {battle_request_at: Time.current})
  end

  def battle_request_ng(data)
    # 断られました
  end
end
