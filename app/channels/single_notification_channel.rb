class SingleNotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "single_notification_#{current_chat_user.id}"
  end

  # App.single_notification.message_send_to({from: js_global_params.current_chat_user, to: this.user_to, message: this.message})
  def message_send_to(data)
    ActionCable.server.broadcast("single_notification_#{data['to']['id']}", data)
  end

  def battle_request_to(data)
    e = data["battle_request"]
    from = ChatUser.find(e["from_id"])
    to = ChatUser.find(e["to_id"])
    data["battle_request"]["from"] = from.js_attributes # 送信元ユーザーの最新の状態のルールを用いるため
    data["battle_request"]["to"] = to.js_attributes
    ActionCable.server.broadcast("single_notification_#{to.id}", data)
  end

  def battle_match_ok(data)
    e = data["battle_request"]
    alice = ChatUser.find(e["from"]["id"]) # 最初にリクエストを送った方
    bob = ChatUser.find(e["to"]["id"])     # 承諾した方
    alice.battle_match_to(bob, chat_room: {battle_request_at: Time.current})
  end

  def battle_match_ng(data)
    e = data["battle_request"]
    message_send_to({"from" => e["to"], "to" => e["from"], "message" => "ごめん"})
  end
end
