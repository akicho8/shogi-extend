module ShareBoard
  class RoomChannel < ApplicationCable::Channel
    class SfenNotReachError < StandardError
    end

    def subscribed
      if room_code.blank?
        reject
        return
      end
      subscribed_track("購読開始")
      stream_from "share_board/room_channel/#{room_code}"
    end

    def unsubscribed
      subscribed_track("購読停止")
    end

    def room_leave(data)
      track(data, "部屋退出", "BYE")
      broadcast(:room_leave_broadcasted, data)
    end

    def force_sync(data)
      track(data, "局面転送", data.slice("turn_offset", "sfen"))
      broadcast(:force_sync_broadcasted, data)
    end

    def sfen_share(data)
      track(data, "指手送信", sfen_share_track_body(data))
      broadcast(:sfen_share_broadcasted, data)
    end

    def received_ok(data)
      if Rails.env.production? || true
        track(data, "指手受信", "OK > #{data['to_user_name']}")
      end
      broadcast(:received_ok_broadcasted, data)
    end

    def sfen_share_not_reach(data)
      x_retry_count = data['x_retry_count']
      track(data, "指手不達", "#{x_retry_count}回目")
      raise SfenNotReachError, "指手不達(#{x_retry_count}回目) : #{data}"
    end

    def title_share(data)
      track(data, "タイトル", "#{data["title"].inspect} に変更")
      broadcast(:title_share_broadcasted, data)
    end

    def setup_info_request(data)
      track(data, "情報要求", "ください > ALL")
      broadcast(:setup_info_request_broadcasted, data)
    end

    def setup_info_send(data)
      if !Rails.env.production?
        track(data, "情報送信", "あげます > #{data["to_user_name"]}")
      end
      broadcast(:setup_info_send_broadcasted, data)
    end

    def clock_box_share(data)
      if data["behaviour"].present?
        values = data["cc_params"].fetch_values("initial_main_min", "initial_read_sec", "initial_extra_sec", "every_plus")
        track(data, "対局時計", "#{data["behaviour"]} (#{values.join(" ")}) #{data["room_code_except_url"]}")
      end
      broadcast(:clock_box_share_broadcasted, data)
    end

    def member_info_share(data)
      track(data, "生存通知", "#{data['alive_notice_count']}回目 LV:#{data['active_level']} (#{data['from_connection_id']})") unless Rails.env.production?
      broadcast(:member_info_share_broadcasted, data)
    end

    def order_switch_share(data)
      track(data, "順番設定", data["order_enable_p"] ? "ON" : "OFF")
      broadcast(:order_switch_share_broadcasted, data)
    end

    def ordered_members_share(data)
      user_names = data["ordered_members"].collect { |e| e["user_name"] }.join(" → ")
      track(data, "順番設定", "#{user_names} (#{data["avatar_king_key"]} #{data["shout_mode_key"]})")
      broadcast(:ordered_members_share_broadcasted, data)
    end

    def message_share(data)
      action = "チャット"
      if data["message_scope_key"] == "is_ms_out"
        action = "観戦チャ"
      end
      track(data, action, data["message"])
      broadcast(:message_share_broadcasted, data)
    end

    def ping_command(data)
      # track(data, "PING", data["start_at"])
      broadcast(:ping_command_broadcasted, data)
    end

    def pong_command(data)
      # track(data, "PONG", data["start_at"])
      broadcast(:pong_command_broadcasted, data)
    end

    def ac_log(data)
      track(data, data["subject"], data["body"])
    end

    def fake_error(data)
      track(data, "エラー発動確認", data)
      broadcast(:fake_error_broadcasted, data)
    end

    def shared_al_add(data)
      track(data, data["label"], data)
      broadcast(:shared_al_add_broadcasted, data)
    end

    private

    def room_code
      params["room_code"].presence
    end

    def broadcast(bc_action, bc_params)
      if v = bc_params.find_all { |k, v| v.nil? }.presence
        v = v.to_h.except(*Array(bc_params["__nil_check_skip_keys__"]))
        if v.present?
          raise ArgumentError, "値が nil のキーがある : #{v.inspect}"
        end
      end
      bc_params = bc_params.merge("API_VERSION" => ShareBoardControllerMethods::API_VERSION)
      ActionCable.server.broadcast("share_board/room_channel/#{room_code}", {bc_action: bc_action, bc_params: bc_params})
    end

    def track(data, action, body)
      key = "共有将棋盤 [#{room_code}] #{action}"
      if Rails.env.development? && false
        SlackAgent.notify(subject: key, body: data)
      end

      SlackAgent.notify(subject: key, body: %(:#{data["ua_icon_key"]}: #{ac_event_str(data)} #{data["from_user_name"]}(#{data["active_level"]}): #{body}).squish)
    end

    def subscribed_track(action)
      if current_user
        body = current_user.name
      else
        body = ""
      end
      SlackAgent.notify(subject: "共有将棋盤 [#{room_code}] #{action}", body: "#{body}")
    end

    def sfen_share_track_body(data)
      lmi = data["lmi"]
      player_location = Bioshogi::Location.fetch(lmi["player_location_key"])

      s = []
      s << %([#{lmi["next_turn_offset"]}])
      s << player_location.mark
      s << lmi["kif_without_from"]
      if v = data["next_user_name"]
        s << "> #{v}"
      end
      if v = data["elapsed_sec"]
        s << "#{-v}秒"
      end
      s.join(" ")
    end

    # ActionCable の JavaScript 側で発生したイベント数がわかる文字列 (接続1 切0)" を返す
    def ac_event_str(data)
      hash = data["ac_events_hash"] || {}

      str = hash.collect { |key, val|
        info = ActionCableEventInfo.fetch(key)
        [info.short_name, val].join("")
      }.join(" ")

      if str.present?
        "(#{str})"
      end
    end
  end
end
