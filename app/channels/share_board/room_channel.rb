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
      track(data, "局面転送", "[#{data["turn"]}手目][#{data["message"]}]")
      broadcast(:force_sync_broadcasted, data)
    end

    def honpu_share(data)
      track(data, "本譜転送", data["sfen"])
      broadcast(:honpu_share_broadcasted, data)
    end

    def sfen_share(data)
      track(data, "指手送信", sfen_share_track_body(data), ":着手:")
      broadcast(:sfen_share_broadcasted, data)
    end

    def received_ok(data)
      if data["debug_mode_p"]
        track(data, "指手受信", "OK > #{data['to_user_name']}", ":OK:")
      end
      broadcast(:received_ok_broadcasted, data)
    end

    def sfen_share_not_reach(data)
      x_retry_count = data['x_retry_count']
      track(data, "指手不達", "#{x_retry_count}回目", ":指手不達:")
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
      values = data["cc_params"].collect { |e| e.fetch_values("initial_main_min", "initial_read_sec", "initial_extra_sec", "every_plus") }
      url = data["current_url"]
      message = [data["cc_key"], values.inspect, url].compact.join(" ")
      track(data, "対局時計", message, ":対局時計:")
      broadcast(:clock_box_share_broadcasted, data)
    end

    def member_info_share(data)
      if data["debug_mode_p"]
        message = "#{data['alive_notice_count']}回目 LV:#{data['active_level']} (#{data['from_connection_id']})"
        track(data, "生存通知", message)
      end
      broadcast(:member_info_share_broadcasted, data)
    end

    def order_switch_share(data)
      message = "順番#{data["order_enable_p"] ? "ON" : "OFF"}を配布"
      track(data, "順番設定", message, ":順番設定:")
      broadcast(:order_switch_share_broadcasted, data)
    end

    def new_order_share(data)
      user_names = []
      # user_names = data["order_unit"]["order_state"].collect { |e| e["user_name"] }.join(" → ")
      # user_names = data["order_unit"]["order_state"] # 動的にかわる
      config = ["illegal_behavior_key", "resign_timing_key"].collect { |e| data[e] }.join(" ")
      message = "オーダー配布 #{user_names} (#{config})"
      track(data, "順番設定", message, ":順番設定:")
      broadcast(:new_order_share_broadcasted, data)
    end

    def message_share(data)
      if data["message_scope_key"] == "is_message_scope_public"
        action = "チャット"
        emoji = ":公開チャット:"
      else
        action = "観戦チャ"
        emoji = ":観戦チャット:"
      end
      track(data, action, data["message"], emoji)
      broadcast(:message_share_broadcasted, data)
    end

    def give_up_share(data)
      track(data, "投了発動", data["message"], ":投了:")
      broadcast(:give_up_share_broadcasted, data)
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
      track(data, data["subject"], data["body"], ":LOG:")
    end

    def fake_error(data)
      track(data, "エラー発動確認", data)
      broadcast(:fake_error_broadcasted, data)
    end

    def shared_al_add(data)
      track(data, data["label"])
      broadcast(:shared_al_add_broadcasted, data)
    end

    def acquire_medal_count_share(data)
      # track(data, "メダル", "#{data["medal_user_name"]} = #{data["acquire_medal_count"]"}")
      medal_user_name = data["medal_user_name"]
      acquire_medal_count = data["acquire_medal_count"]
      track(data, "メダル＝", "#{medal_user_name} = #{acquire_medal_count}")
      broadcast(:acquire_medal_count_share_broadcasted, data)
    end

    def medal_add_to_user_share(data)
      # track(data, "メダル", "#{data["medal_user_name"]} = #{data["acquire_medal_count"]"}")
      medal_user_name = data["medal_user_name"]
      acquire_medal_plus = data["acquire_medal_plus"]
      track(data, "メダル＋", "#{medal_user_name} + #{acquire_medal_plus}")
      broadcast(:medal_add_to_user_share_broadcasted, data)
    end

    def user_kick(data)
      track(data, "強制退出", "KILL #{data["kicked_user_name"]}")
      broadcast(:user_kick_broadcasted, data)
    end

    def odai_share(data)
      track(data, "お題配送", data["odai"], ":お題:")
      broadcast(:odai_share_broadcasted, data)
    end

    def odai_delete(data)
      track(data, "お題削除")
      broadcast(:odai_delete_broadcasted, data)
    end

    def vote_select_share(data)
      track(data, "投票選択", data["voted_latest_index"], ":お題:")
      broadcast(:vote_select_share_broadcasted, data)
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

    def track(data, action, message = nil, emoji = nil)
      subject = []
      subject << "共有将棋盤"
      subject << "[#{room_code}]"
      subject << action
      subject = subject.join(" ")

      body = []
      body << ":#{data["ua_icon_key"]}:"
      body << ac_event_str(data)
      body << data["from_user_name"]
      if v = data["active_level"]
        body << v.to_s + ":"
      end
      if v = message.presence
        body << v
      end
      body = body.join(" ").squish

      SlackAgent.notify(subject: subject, body: body, emoji: emoji)
    end

    def subscribed_track(action)
      if current_user
        body = "User ##{current_user.id} #{current_user.name} #{current_user.email}"
      else
        body = "User 不明"
      end
      SlackAgent.notify(subject: "共有将棋盤 [#{room_code}] #{action}", body: "#{body}")
    end

    def sfen_share_track_body(data)
      lmi = data["lmi"]
      player_location = LocationInfo.fetch(lmi["player_location_key"])

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
