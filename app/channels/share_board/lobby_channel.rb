module ShareBoard
  class LobbyChannel < ApplicationCable::Channel
    class << self
      def redis_db_index
        AppConfig.fetch(:redis_db_for_sbx)
      end
    end

    def subscribed
      simple_track("購読開始")
      stream_from "share_board/lobby_channel"

      data = { sbx_rules_members: SbxRuleInfo.sbx_rules_members }
      broadcast(:subscribed_broadcasted, data)
    end

    def unsubscribed
      simple_track("購読停止")
    end

    def rule_select(data)
      sbx_rule_info = SbxRuleInfo.fetch(data["sbx_rule_key"])
      track(data, "規則選択", sbx_rule_info.key)
      data = data.merge(sbx_rule_info.member_add(data))
      broadcast(:rule_select_broadcasted, data)
    end

    def rule_unselect(data)
      track(data, "規則解除", "")
      SbxRuleInfo.member_delete(data)
      data = data.merge(sbx_rules_members: SbxRuleInfo.sbx_rules_members)
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
      bc_params = bc_params.merge("API_VERSION" => ShareBoardControllerMethods::API_VERSION)
      ActionCable.server.broadcast("share_board/lobby_channel", {bc_action: bc_action, bc_params: bc_params})
    end

    def track(data, action, body)
      key = "共有将棋盤 [ロビー] #{action}"
      if Rails.env.development? && false
        SlackAgent.message_send(key: key, body: data)
      end
      prefix = data["from_user_name"] + ":"
      SlackAgent.message_send(key: key, body: "#{data["ua_icon"]} #{prefix} #{body}")
    end

    def simple_track(action)
      if current_user
        body = current_user.name
      else
        body = ""
      end
      SlackAgent.message_send(key: "共有将棋盤 [ロビー] #{action}", body: body)
    end
  end
end
