module Xmovie
  class GlobalRoomChannel < ApplicationCable::Channel
    # 回線不調で何回も呼ばれる
    def subscribed
      # subscribed_track("購読開始")
      stream_from "xmovie/global_room_channel"
      if current_user
        stream_for(current_user)
      end
    end

    # 回線不調で何回も呼ばれる
    def unsubscribed
      # subscribed_track("購読停止")
    end

    # 接続後に1回だけ呼ぶ
    # REVIEW: 最初に1回実行したいなら ActionCable ではなく Nuxt の fetch で行うべきじゃないか？
    def setup_request(data)
      XmovieRecord.zombie_kill # ゾンビを成仏させる

      # みんなの履歴
      XmovieRecord.everyone_broadcast

      if current_user
        # あなたの履歴
        current_user.my_records_singlecast

        # 直近1件を送る
        if v = current_user.xmovie_records.success_only.order(created_at: :desc).first
          current_user.done_record_singlecast(v, noisy: false)
        end
      end
    end

    # def title_share(data)
    #   track(data, "タイトル", "#{data["title"].inspect} に変更")
    #   broadcast(:title_share_broadcasted, data)
    # end

    def ac_log(data)
      track(data, data["subject"], data["body"])
    end

    private

    def broadcast(bc_action, bc_params)
      if v = bc_params.find_all { |k, v| v.nil? }.presence
        v = v.to_h.except(*Array(bc_params["__nil_check_skip_keys__"]))
        if v.present?
          raise ArgumentError, "値が nil のキーがある : #{v.inspect}"
        end
      end
      # bc_params = bc_params.merge("API_VERSION" => ShareBoardControllerMethods::API_VERSION)
      ActionCable.server.broadcast("xmovie/global_room_channel", {bc_action: bc_action, bc_params: bc_params})
    end

    def track(data, action, body)
      key = "動画生成 [#{global_room_code}] #{action}"
      if Rails.env.development? && false
        SlackAgent.message_send(key: key, body: data)
      end

      SlackAgent.message_send(key: key, body: %(:#{data["ua_icon_key"]}: #{data["from_user_name"]}(#{data["active_level"]}): #{body}).squish)
    end

    def subscribed_track(action)
      if current_user
        body = current_user.name
      else
        body = ""
      end
      SlackAgent.message_send(key: "動画生成 #{action}", body: "#{body}")
    end
  end
end
