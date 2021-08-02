module Xconv
  class RoomChannel < ApplicationCable::Channel
    def subscribed
      subscribed_track("購読開始")
      stream_from "xconv/room_channel"
      XconvRecord.xconv_info_broadcast
    end

    def unsubscribed
      subscribed_track("購読停止")
    end

    def title_share(data)
      track(data, "タイトル", "#{data["title"].inspect} に変更")
      broadcast(:title_share_broadcasted, data)
    end

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
      ActionCable.server.broadcast("xconv/room_channel", {bc_action: bc_action, bc_params: bc_params})
    end

    def track(data, action, body)
      key = "GIF変換 [#{room_code}] #{action}"
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
      SlackAgent.message_send(key: "GIF変換 #{action}", body: "#{body}")
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
  end
end
