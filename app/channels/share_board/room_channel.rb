# ~/src/shogi-extend/nuxt_side/components/ShareBoard/room/mod_room_channel.js
module ShareBoard
  class RoomChannel < ApplicationCable::Channel
    class SfenNotReachError < StandardError
    end

    # before_subscribe do
    # end
    # after_subscribe do
    # end
    # before_unsubscribe do
    # end
    # after_unsubscribe do
    # end

    ################################################################################

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

    ################################################################################

    def room_leave_share(data)
      track(data, subject: "部屋退出", body: "BYE")
      broadcast(:room_leave_share_broadcasted, data)
    end

    def force_sync(data)
      track(data, subject: "局面転送", body: "[#{data["turn"]}手目][#{data["message"]}]")
      broadcast(:force_sync_broadcasted, data)
    end

    def honpu_share(data)
      track(data, subject: "本譜転送", body: data["sfen"])
      broadcast(:honpu_share_broadcasted, data)
    end

    def sfen_sync(data)
      track(data, subject: "指手送信", body: sfen_sync_track_body(data), emoji: ":着手:")
      broadcast(:sfen_sync_broadcasted, data)
    end

    def resend_receive_success(data)
      if data["debug_mode_p"]
        track(data, subject: "指手受信", body: "OK → #{data['to_user_name'].inspect}", emoji: ":OK:")
      end
      broadcast(:resend_receive_success_broadcasted, data)
    end

    def resend_failed_logging(data)
      resend_failed_count = data["resend_failed_count"]
      track(data, subject: "指手不達", body: "#{resend_failed_count}回目", emoji: ":指手不達:")
      # raise SfenNotReachError, "指手不達(#{resend_failed_count}回目) : #{data}"
    end

    ################################################################################

    def room_name_share(data)
      Room.fetch(room_key).update!(name: data["room_name"])
      track(data, subject: "部屋名", body: "#{data["room_name"].inspect} に変更")
      broadcast(:room_name_share_broadcasted, data)
    end

    ################################################################################

    def setup_info_request(data)
      track(data, subject: "情報要求", body: "ください > ALL")
      broadcast(:setup_info_request_broadcasted, data)
    end

    def setup_info_send(data)
      active_level = data["active_level"]
      track(data, subject: "情報送信", body: "あげます (LV:#{active_level}) > #{data["to_user_name"]}")
      broadcast(:setup_info_send_broadcasted, data)
    end

    def clock_box_share(data)
      values = data["cc_params"].collect do |e|
        e.fetch_values("initial_main_min", "initial_read_sec", "initial_extra_min", "every_plus")
      end
      message = [
        data["cc_behavior_key"],
        data["cc_behavior_name"],
        values,
        data["member_data"],
        data["current_url"],
      ].compact
      track(data, subject: "対局時計", body: message, emoji: ":対局時計:", level: data["log_level"])
      broadcast(:clock_box_share_broadcasted, data)
    end

    def member_info_share(data)
      body = [
        "#{data['alive_notice_count']}回目",
        "LV:#{data['active_level']}",
      ].join(" ")
      track(data, subject: "生存通知", body: body)
      broadcast(:member_info_share_broadcasted, data)
    end

    def order_switch_share(data)
      message = "順番#{data["order_enable_p"] ? "ON" : "OFF"}を配布"
      track(data, subject: "順番設定", body: message, emoji: ":順番設定:")
      broadcast(:order_switch_share_broadcasted, data)
    end

    def order_draft_publish(data)
      user_names = []
      # user_names = data["order_flow"]["order_operation"].collect { |e| e["user_name"] }.join(" → ")
      # user_names = data["order_flow"]["order_operation"] # 動的にかわる
      config = ["foul_mode_key"].collect { |e| data[e] }.join(" ")
      message = "オーダー配布 #{user_names} (#{config})"
      track(data, subject: "順番設定", body: message, emoji: ":順番設定:")
      broadcast(:order_draft_publish_broadcasted, data)
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

    def resign_share(data)
      track(data, subject: "投了発動", body: data["content"], emoji: ":投了:")
      broadcast(:resign_share_broadcasted, data)
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

    def illegal_block_modal_start(data)
      broadcast(:illegal_block_modal_start_broadcasted, data)
    end

    def illegal_block_yes_no(data)
      broadcast(:illegal_block_yes_no_broadcasted, data)
    end

    ################################################################################

    def xprofile_load(data)
      user_name = data["reqeust_user_name"]
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
        broadcast(:xprofile_load_broadcasted, data)
      end
    end

    def xprofile_share(data)
      track(data, subject: "バッジ＝", body: data["users_match_record"])
      broadcast(:xprofile_share_broadcasted, data)
    end

    ################################################################################

    def user_kick(data)
      track(data, subject: "強制退出", body: "KILL #{data["kicked_user_name"]}")
      broadcast(:user_kick_broadcasted, data)
    end

    ################################################################################

    def quiz_share(data)
      track(data, subject: "お題配送", body: data["quiz"], emoji: ":お題:")
      broadcast(:quiz_share_broadcasted, data)
    end

    def quiz_delete(data)
      track(data, subject: "お題削除")
      broadcast(:quiz_delete_broadcasted, data)
    end

    def quiz_voted_index_share(data)
      track(data, subject: "投票選択", body: data["quiz_voted_index"], emoji: ":お題:")
      broadcast(:quiz_voted_index_share_broadcasted, data)
    end

    ################################################################################

    private

    def room_key
      params["room_key"].presence
    end

    def broadcast(...)
      Broadcaster.new(room_key).call(...)
    end

    def subject_build(action)
      ["共有将棋盤", "[#{room_key}]", *action].join(" ")
    end

    def body_build(data, options)
      body = []
      body << data["from_connection_id"].inspect
      body << ac_event_str(data)
      if v = data["active_level"]
        body << "LV:#{v}".inspect
      end
      body << [":", data["ua_icon_key"], ":"].join
      body << data["from_user_name"].inspect
      if v = options[:body].presence
        if !v.kind_of?(String)
          v = v.inspect
        end
        body << v
      end
      body = body.join(" ").squish
    end

    def track(data, **options)
      subject = subject_build(options[:subject])
      body = body_build(data, options)
      AppLog.call(subject: subject, body: body, emoji: options[:emoji], level: options[:level])
    end

    def subscribed_track(action)
      subject = subject_build(action)

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

    def sfen_sync_track_body(data)
      last_move_info_attrs = data["last_move_info_attrs"]
      player_location = LocationInfo.fetch(last_move_info_attrs["player_location_key"])
      next_turn_offset = last_move_info_attrs["next_turn_offset"]

      s = []
      s << "#{next_turn_offset}手目"
      s << player_location.mark
      s << last_move_info_attrs["kif_without_from"].inspect
      if v = data["next_user_name"]
        s << "→ #{v.inspect}"
      end
      if v = data["elapsed_sec"]
        s << "(#{-v}秒)"
      end
      if v = data["illegal_hv_list"].presence
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
