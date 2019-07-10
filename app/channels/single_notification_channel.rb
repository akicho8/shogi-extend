class SingleNotificationChannel < ApplicationCable::Channel
  def subscribed
    if current_user
      stream_for current_user
    end
  end

  # App.single_notification.message_send_to({from: js_global.current_user, to: this.user_to, message: this.message})
  def message_send_to(data)
    to   = Colosseum::User.find(data["to"]["id"])
    from = Colosseum::User.find(data["from"]["id"])

    # CPU同士の会話は無限ループになるため禁止
    if to.race_info.auto_message_response && from.race_info.auto_message_response
      return
    end

    # 受信者がCPUなら自動的に返事をする
    if to.race_info.auto_message_response
      message_send_to("from" => to, "to" => from, "message" => "#{from.name}さんは#{data["message"]}なんですね")
      return
    end

    # 相手が人間
    self.class.broadcast_to(to, data)
  end

  def battle_request_to(data)
    e = data["battle_request"]
    from = Colosseum::User.find(e["from_id"])
    to = Colosseum::User.find(e["to_id"])
    if to.race_info.auto_request_ok
      battle_match_ok(data)
    else
      data["battle_request"]["from"] = ams_sr(from, serializer: Colosseum::CurrentUserSerializer) # 送信元ユーザーの最新の状態のルールを用いるため
      data["battle_request"]["to"] = ams_sr(to)
      self.class.broadcast_to(to, data)
    end
  end

  def battle_match_ok(data)
    e = data["battle_request"]
    from = Colosseum::User.find(e["from_id"]) # 最初にリクエストを送った方
    to = Colosseum::User.find(e["to_id"])     # 承諾した方
    from.battle_with(to)
  end

  def battle_match_ng(data)
    e = data["battle_request"]
    message_send_to("from" => e["to"], "to" => e["from"], "message" => "ごめん")
  end
end
