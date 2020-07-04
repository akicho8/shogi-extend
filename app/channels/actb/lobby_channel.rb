module Actb
  class LobbyChannel < BaseChannel
    MATCHING_RATE_THRESHOLD_DEFAULT = 50

    class << self
      def matching_users_add(user)
        user.actb_setting.rule.matching_users_add(user)
      end

      def matching_users_delete(user)
        Actb::Rule.matching_users_delete(user) # すべてのルールを対象に解除する
      end
    end

    ################################################################################

    def subscribed
      stream_from "actb/lobby_channel"
      matching_users_broadcast
    end

    def unsubscribed
      self.class.matching_users_delete(current_user)
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

    # from app/javascript/actb_app/the_matching_interval.js
    def matching_search(data)
      data = data.to_options

      current_user.reload # current_user.setting.rule_key を更新する

      matching_rate_threshold = data[:matching_rate_threshold] || MATCHING_RATE_THRESHOLD_DEFAULT

      if ordered_info = ordered_infos.first
        gap, opponent = ordered_info
        if gap < matching_rate_threshold
          room_create(opponent, current_user) # 元々いた人を左側に配置
          return
        end
      end

      self.class.matching_users_add(current_user)
    end

    def matching_cancel(data)
      self.class.matching_users_delete(current_user)
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

    def room_create(*users)
      self.class.matching_users_delete(*users)

      # app/models/actb/room.rb
      Room.create!(rule: rule) do |e|
        users.each do |user|
          e.memberships.build(user: user)
        end
      end
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
