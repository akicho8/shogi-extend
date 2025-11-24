module ShareBoard
  class LobbyChannel < ApplicationCable::Channel
    class << self
      def redis_db_index
        AppConfig.fetch(:redis_db_for_share_board_lobby)
      end
    end

    def subscribed
      notify("購読開始")
      stream_from "share_board/lobby_channel"

      data = { xmatch_rules_members: XmatchRuleInfo.xmatch_rules_members }
      broadcast(:subscribed_broadcasted, data)
    end

    def unsubscribed
      notify("購読停止")
    end

    def rule_select(data)
      xmatch_rule_info = XmatchRuleInfo.fetch(data["xmatch_rule_key"])
      track(data, "規則選択", xmatch_rule_info.name)
      data = data.merge(xmatch_rule_info.member_add(data))
      data = data.merge(xmatch_rules_members: XmatchRuleInfo.xmatch_rules_members)
      broadcast(:rule_select_broadcasted, data)
    end

    def rule_unselect(data)
      track(data, "規則解除", "")
      data = data.merge(XmatchRuleInfo.member_delete(data))
      data = data.merge(xmatch_rules_members: XmatchRuleInfo.xmatch_rules_members)
      broadcast(:rule_unselect_broadcasted, data)
    end

    private

    def broadcast(bc_action, bc_params)
      if v = bc_params.find_all { |k, v| v.nil? }.presence
        v = v.to_h.except(*Array(bc_params["__nil_check_skip_keys__"]))
        if v.present?
          raise ArgumentError, "値が nil のキーがある : #{v.inspect}"
        end
      end
      bc_params = bc_params.merge("SERVER_SIDE_API_VERSION" => AppConfig[:share_board_api_version])
      ActionCable.server.broadcast("share_board/lobby_channel", { bc_action: bc_action, bc_params: bc_params })
    end

    def track(data, action, body)
      key = "自動マッチング #{action}"
      if Rails.env.development? && false
        AppLog.info(subject: key, body: data)
      end
      prefix = data["from_user_name"] + ":"
      AppLog.info(subject: key, body: ":#{data["ua_icon_key"]}: #{prefix} #{body}")
    end

    def notify(action)
      if current_user
        body = current_user.name
      else
        body = "(未ログイン)"
      end
      AppLog.info(subject: "自動マッチング #{action}", body: body)
    end
  end
end
