module Actb
  class LobbyChannel < BaseChannel
    MATCHING_RATE_THRESHOLD_DEFAULT = 50

    def subscribed
      __event_notify__(__method__)
      return reject unless current_user

      stream_from "actb/lobby_channel"
      Actb::Rule.matching_user_ids_broadcast
    end

    def unsubscribed
      __event_notify__(__method__)
      Actb::Rule.matching_users_delete_from_all_rules(current_user)
    end

    def speak(data)
      data = data.to_options
      current_user.lobby_speak(data[:message_body])
      execution_interrupt_hidden_command(data[:message_body])
    end

    def execution_interrupt_hidden_command(str)
      if md = str.to_s.squish.match(/^\/(?<command_line>.*)/)
        args = md["command_line"].split
        command = args.shift
        if command == "ping"
          current_user.lobby_speak("pong")
        end
        if command == "rule_key"
          current_user.lobby_speak(current_user.rule_key)
          current_user.lobby_speak(current_user.reload.rule_key)
        end
      end
    end

    # from app/javascript/actb_app/application_matching.js
    def matching_search(data)
      __event_notify__(__method__, data)
      data = data.to_options
      raise ArgumentError, data.inspect if data[:session_lock_token].blank?

      current_user.reload # current_user.actb_setting.* を最新にするため

      # session_lock_token が変化していたら別のブラウザで対戦が開始されたことがわかる
      unless current_user.session_lock_token_valid?(data[:session_lock_token])
        ActionCable.server.broadcast("actb/lobby_channel", bc_action: :session_lock_token_invalid_narrowcasted, bc_params: data)
        return
      end

      if data[:practice_p]
        users = [User.bot, current_user]
        if users[Actb::Config[:leader_index]].robot?
          raise "ロボットはリーダーになれない"
        end
        room_create(users, practice: data[:practice_p])
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
      Actb::Rule.matching_users_delete_from_all_rules(current_user)
    end

    ################################################################################

    def ordered_infos_debug
      ordered_infos.collect { |gap, e| { gap: gap, id: e.id, name: e.name } }
    end

    def ordered_infos
      matching_users_without_self.collect { |e| [(e.rating - current_user.rating).abs, e] }.sort
    end

    def matching_users_without_self
      matching_users.reject { |e| e == current_user }
    end

    def matching_users_include?(user)
      redis.matching_users_include?(user)
    end

    def room_create(users, attributes = {})
      users.each { |e| Actb::Rule.matching_users_delete_from_all_rules(e) }

      # app/models/actb/room.rb
      Room.create_with_members!(users, attributes.merge(rule: rule))
    end

    def rule
      current_user.actb_setting.rule
    end
    delegate :matching_users, :matching_user_ids, to: :rule

    def lobby_speak(message_body)
      current_user.actb_lobby_messages.create!(body: message_body)
    end
  end
end
