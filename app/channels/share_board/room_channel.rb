module ShareBoard
  class RoomChannel < ApplicationCable::Channel
    class SfenNotReachError < StandardError
    end

    def subscribed
      if room_key.blank?
        reject
        return
      end
      subscribed_track("購読開始")
      stream_from "share_board/room_channel/#{room_key}"
    end

    def unsubscribed
      subscribed_track("購読停止")
    end

    def room_leave(data)
      track(data, subject: "部屋退出", body: "BYE")
      broadcast(:room_leave_broadcasted, data)
    end

    def force_sync(data)
      track(data, subject: "局面転送", body: "[#{data["turn"]}手目][#{data["message"]}]")
      broadcast(:force_sync_broadcasted, data)
    end

    def honpu_share(data)
      track(data, subject: "本譜転送", body: data["sfen"])
      broadcast(:honpu_share_broadcasted, data)
    end

    def sfen_share(data)
      track(data, subject: "指手送信", body: sfen_share_track_body(data), emoji: ":着手:")
      broadcast(:sfen_share_broadcasted, data)
    end

    def rs_receive_success(data)
      if data["debug_mode_p"]
        track(data, subject: "指手受信", body: "OK > #{data['to_user_name']}", emoji: ":OK:")
      end
      broadcast(:rs_receive_success_broadcasted, data)
    end

    def rs_failed_notify(data)
      rs_failed_count = data["rs_failed_count"]
      track(data, subject: "指手不達", body: "#{rs_failed_count}回目", emoji: ":指手不達:")
      # raise SfenNotReachError, "指手不達(#{rs_failed_count}回目) : #{data}"
    end

    def title_share(data)
      track(data, subject: "タイトル", body: "#{data["title"].inspect} に変更")
      broadcast(:title_share_broadcasted, data)
    end

    def setup_info_request(data)
      track(data, subject: "情報要求", body: "ください > ALL")
      broadcast(:setup_info_request_broadcasted, data)
    end

    def setup_info_send(data)
      if !Rails.env.production?
        track(data, subject: "情報送信", body: "あげます > #{data["to_user_name"]}")
      end
      broadcast(:setup_info_send_broadcasted, data)
    end

    def clock_box_share(data)
      values = data["cc_params"].collect do |e|
        e.fetch_values("initial_main_min", "initial_read_sec", "initial_extra_min", "every_plus")
      end
      message = [data["cc_behavior_key"], values.inspect, data["member_data"], data["current_url"]].compact.join("\n\n")
      track(data, subject: "対局時計", body: message, emoji: ":対局時計:", level: data["log_level"])
      broadcast(:clock_box_share_broadcasted, data)
    end

    def member_info_share(data)
      if data["debug_mode_p"]
        body = [
          "#{data['alive_notice_count']}回目",
          "LV:#{data['active_level']}",
          "(#{data['from_connection_id']})",
        ].join(" ")
        track(data, subject: "生存通知", body: body)
      end
      broadcast(:member_info_share_broadcasted, data)
    end

    def order_switch_share(data)
      message = "順番#{data["order_enable_p"] ? "ON" : "OFF"}を配布"
      track(data, subject: "順番設定", body: message, emoji: ":順番設定:")
      broadcast(:order_switch_share_broadcasted, data)
    end

    def new_order_share(data)
      user_names = []
      # user_names = data["order_unit"]["order_state"].collect { |e| e["user_name"] }.join(" → ")
      # user_names = data["order_unit"]["order_state"] # 動的にかわる
      config = ["foul_mode_key", "auto_resign_key"].collect { |e| data[e] }.join(" ")
      message = "オーダー配布 #{user_names} (#{config})"
      track(data, subject: "順番設定", body: message, emoji: ":順番設定:")
      broadcast(:new_order_share_broadcasted, data)
    end

    def think_mark_share(data)
      track(data, subject: "思考印", body: data["think_mark_command"], emoji: ":思考印:")
      broadcast(:think_mark_share_broadcasted, data)
    end

    def message_share(data)
      if data["message_scope_key"] == "ms_public"
        action = "チャット"
        emoji = ":公開チャット:"
      else
        action = "観戦チャ"
        emoji = ":観戦チャット:"
      end
      track(data, subject: action, body: data["content"], emoji: emoji)
      ShareBoard::ChatMessageBroadcastJob.perform_later(room_key, data)
    end

    # /gpt コマンド
    def ai_something_say(data)
      ShareBoard::ResponderSomethingSayJob.perform_later(data.merge(room_key: room_key))
    end

    def give_up_share(data)
      track(data, subject: "投了発動", body: data["content"], emoji: ":投了:")
      broadcast(:give_up_share_broadcasted, data)
    end

    def ping_command(data)
      # track(data, subject: "PING", body: data["start_at"])
      broadcast(:ping_command_broadcasted, data)
    end

    def pong_command(data)
      # track(data, subject: "PONG", body: data["start_at"])
      broadcast(:pong_command_broadcasted, data)
    end

    def ac_log(data)
      track(data, subject: data["subject"], body: data["body"], emoji: data["emoji"] || ":LOG:", level: data["level"])
    end

    def fake_error(data)
      track(data, subject: "エラー発動確認")
      broadcast(:fake_error_broadcasted, data)
    end

    def al_share(data)
      track(data, subject: data["label"])
      broadcast(:al_share_broadcasted, data)
    end

    ################################################################################

    def xbadge_load(data)
      user_name = data["xbadge_reqeust"]
      users_match_record = nil
      if room = Room[room_key]
        if user = User[user_name]
          if roomship = room.roomships.find_by(user: user)
            users_match_record = roomship.users_match_record
          end
        end
      end
      if users_match_record
        data["users_match_record"] = users_match_record
        broadcast(:xbadge_load_broadcasted, data)
      end
    end

    def xbadge_dist(data)
      track(data, subject: "バッジ＝", body: data["users_match_record"])
      broadcast(:xbadge_dist_broadcasted, data)
    end

    ################################################################################

    def user_kick(data)
      track(data, subject: "強制退出", body: "KILL #{data["kicked_user_name"]}")
      broadcast(:user_kick_broadcasted, data)
    end

    def odai_share(data)
      track(data, subject: "お題配送", body: data["odai"], emoji: ":お題:")
      broadcast(:odai_share_broadcasted, data)
    end

    def odai_delete(data)
      track(data, subject: "お題削除")
      broadcast(:odai_delete_broadcasted, data)
    end

    def vote_select_share(data)
      track(data, subject: "投票選択", body: data["voted_latest_index"], emoji: ":お題:")
      broadcast(:vote_select_share_broadcasted, data)
    end

    private

    def room_key
      params["room_key"].presence
    end

    def broadcast(...)
      Broadcaster.new(room_key).call(...)
    end

    def track(data, **options)
      subject = []
      subject << "共有将棋盤"
      subject << "[#{room_key}]"
      if v = options[:subject].presence
        subject << v
      end
      subject = subject.join(" ")

      body = []
      body << [":", data["ua_icon_key"], ":"].join # FIXME: Slackを使っていないので入れる意味がない
      body << ac_event_str(data)
      body << data["from_user_name"].inspect
      if v = data["active_level"]
        body << v.to_s + ":"
      end
      if v = options[:body].presence
        body << v
      end
      body = body.join(" ").squish

      AppLog.call(subject: subject, body: body, emoji: options[:emoji], level: options[:level])
    end

    def subscribed_track(action)
      subject = [
        "共有将棋盤",
        "[#{room_key}]",
        action,
      ].join(" ")

      if current_user
        body = [
          "ログイン済み",
          "##{current_user.id}",
          current_user.name,
          current_user.email,
        ].join(" ")
      else
        body = "ゲスト"
      end

      AppLog.info(subject: subject, body: body)
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
      if v = data["illegal_names"].presence
        s << "反則:#{v}"
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
