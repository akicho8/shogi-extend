class SingleNotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "single_notification_#{current_user.id}"
  end

  # App.single_notification.message_send_to({from: js_global_params.current_user, to: this.user_to, message: this.message})
  def message_send_to(data)
    ActionCable.server.broadcast("single_notification_#{data['to']['id']}", data)
  end

  def battle_request_to(data)
    e = data["battle_request"]
    from = Fanta::User.find(e["from_id"])
    to = Fanta::User.find(e["to_id"])
    if to.race_info.auto_request_ok
      battle_match_ok(data)
    else
      data["battle_request"]["from"] = ams_sr(from, serializer: Fanta::CurrentUserSerializer) # 送信元ユーザーの最新の状態のルールを用いるため
      data["battle_request"]["to"] = ams_sr(to)
      ActionCable.server.broadcast("single_notification_#{to.id}", data)
    end
  end

  def battle_match_ok(data)
    e = data["battle_request"]
    from = Fanta::User.find(e["from_id"]) # 最初にリクエストを送った方
    to = Fanta::User.find(e["to_id"])     # 承諾した方
    from.battle_with(to)
  end

  def battle_match_ng(data)
    e = data["battle_request"]
    message_send_to({"from" => e["to"], "to" => e["from"], "message" => "ごめん"})
  end
end
