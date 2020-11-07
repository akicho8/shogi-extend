module Emox
  class LobbyChannel < BaseChannel
    MATCHING_RATE_THRESHOLD_DEFAULT = 50

    def subscribed
      return reject unless current_user

      stream_from "emox/lobby_channel"
      Emox::Rule.matching_user_ids_broadcast
    end

    def unsubscribed
      Emox::Rule.matching_users_delete_from_all_rules(current_user)
    end

    # from app/javascript/emox_app/application_matching.js
    def matching_search(data)
      data = data.to_options
      raise ArgumentError, data.inspect if data[:session_lock_token].blank?

      current_user.reload # current_user.emox_setting.* を最新にするため

      # session_lock_token が変化していたら別のブラウザで対戦が開始されたことがわかる
      unless current_user.emox_session_lock_token_valid?(data[:session_lock_token])
        ActionCable.server.broadcast("emox/lobby_channel", bc_action: :session_lock_token_invalid_narrowcasted, bc_params: data)
        return
      end

      matching_rate_threshold = data[:matching_rate_threshold] || MATCHING_RATE_THRESHOLD_DEFAULT

      if ordered_info = ordered_infos.first
        gap, opponent = ordered_info
        if gap < matching_rate_threshold
          room_create([opponent, current_user]) # 元々いた人を左側に配置(どちらをリーダーにするかに影響する)
          return
        end
      end

      rule.matching_users_add(current_user)
    end

    # すべてのルールから解除する
    def matching_cancel(data)
      Emox::Rule.matching_users_delete_from_all_rules(current_user)
    end

    ################################################################################

    def ordered_infos_debug
      ordered_infos.collect { |gap, e| { gap: gap, id: e.id, name: e.name } }
    end

    def ordered_infos
      matching_users_without_self.collect { |e| [(0 - 0).abs, e] }.sort
    end

    def matching_users_without_self
      matching_users.reject { |e| e == current_user }
    end

    def matching_users_include?(user)
      redis.matching_users_include?(user)
    end

    def room_create(users, attributes = {})
      # app/models/emox/room.rb
      Room.create_with_members!(users, {rule: rule}.merge(attributes))
    end

    def rule
      current_user.emox_setting.rule
    end
    delegate :matching_users, :matching_user_ids, to: :rule
  end
end
