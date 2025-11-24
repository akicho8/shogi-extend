module Kiwi
  class LemonRoomChannel < ApplicationCable::Channel
    # 回線不調で何回も呼ばれる
    def subscribed
      # subscribed_track("購読開始")
      stream_from "kiwi/lemon_room_channel"
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
      Kiwi::Lemon.zombie_kill # ゾンビを成仏させる

      # みんなの履歴
      Kiwi::Lemon.everyone_broadcast

      if current_user
        # あなたの履歴
        current_user.kiwi_my_lemons_singlecast

        # 直近1件を送る
        if v = current_user.kiwi_lemons.success_only.order(created_at: :desc).first
          current_user.kiwi_done_lemon_singlecast(v, noisy: false)
        end

        # 管理用
        if current_user.staff? || Rails.env.development?
          current_user.kiwi_admin_info_singlecasted
        end
      end
    end

    private

    def broadcast(bc_action, bc_params)
      if v = bc_params.find_all { |k, v| v.nil? }.presence
        v = v.to_h.except(*Array(bc_params["__nil_check_skip_keys__"]))
        if v.present?
          raise ArgumentError, "値が nil のキーがある : #{v.inspect}"
        end
      end
      ActionCable.server.broadcast("kiwi/lemon_room_channel", { bc_action: bc_action, bc_params: bc_params })
    end
  end
end
