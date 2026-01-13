module Kiwi
  class BananaRoomChannel < ApplicationCable::Channel
    # 回線不調で何回も呼ばれる
    def subscribed
      if banana_id.blank?
        reject
        return
      end
      # subscribed_track("購読開始")
      stream_from "kiwi/banana_room_channel/#{banana_id}"
      if current_user
        stream_for(current_user) # これは他と衝突する？
      end
    end

    # 回線不調で何回も呼ばれる
    def unsubscribed
      # subscribed_track("購読停止")
    end

    # 接続後に1回だけ呼ぶ
    # REVIEW: 最初に1回実行したいなら ActionCable ではなく Nuxt の fetch で行うべきじゃないか？
    def setup_request(data)
      # Kiwi::Lemon.zombie_kill # ゾンビを成仏させる
      #
      # # みんなの履歴
      # Kiwi::Lemon.everyone_broadcast
      #
      if current_user
        # あなたの履歴
        # current_user.kiwi_my_lemons_singlecast
        #
        # # 直近1件を送る
        # if v = current_user.kiwi_lemons.success_only.order(created_at: :desc).first
        #   current_user.kiwi_done_lemon_singlecast(v, noisy: false)
        # end
        current_user.kiwi_banana_message_pong_singlecast
        current_banana.kiwi_banana_message_pong_broadcast
      end
    end

    def speak(data)
      if current_user
        current_user.kiwi_banana_message_speak(current_banana, data["message_body"])
      end
    end

    private

    def broadcast(bc_action, bc_params)
      if v = bc_params.find_all { |k, v| v.nil? }.presence
        v = v.to_h.except(*Array(bc_params["__nullable_attributes__"]))
        if v.present?
          raise ArgumentError, "値が nil のキーがある : #{v.inspect}"
        end
      end
      ActionCable.server.broadcast("kiwi/banana_room_channel/#{banana_id}", { bc_action: bc_action, bc_params: bc_params })
    end

    def banana_id
      params["banana_id"].presence
    end

    def current_banana
      @current_banana ||= Kiwi::Banana.find(banana_id)
    end
  end
end
