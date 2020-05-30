module Actb
  class LobbyChannel < BaseChannel
    MATCHING_RATE_THRESHOLD_DEFAULT = 50

    delegate :matching_list_hash, to: "self.class"

    class << self
      def matching_list_hash
        RuleInfo.inject({}) do |a, e|
          a.merge(e.key => redis.smembers(e.redis_key).collect(&:to_i))
        end
      end
    end

    ################################################################################

    def subscribed
      stream_from "actb/lobby_channel"
      common_broadcast
    end

    def unsubscribed
      matching_list_remove(current_user)
    end

    def speak(data)
      data = data.to_options
      current_user.actb_lobby_messages.create!(body: data[:message_body])
      execution_interrupt_hidden_command(data[:message_body])
    end

    def execution_interrupt_hidden_command(str)
      if md = str.to_s.squish.match(/^\/(?<command_line>.*)/)
        args = md["command_line"].split
        command = args.shift
        if command == "ping"
          current_user.actb_lobby_messages.create!(body: "pong")
        end
        if command == "rule_key"
          lobby_speak(current_user.rule_key)
          lobby_speak(current_user.reload.rule_key)
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

      matching_list_add(current_user)
    end

    def matching_cancel(data)
      matching_list_remove(current_user)
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

    def matching_users
      redis.smembers(redis_key).collect { |e| Colosseum::User.find(e) }
    end

    def matching_list
      redis.smembers(redis_key).collect(&:to_i)
    end

    def matching_list_add(user)
      redis.sadd(redis_key, user.id)
      common_broadcast
    end

    def matching_member?(user)
      redis.sismember(redis_key, user.id)
    end

    def matching_list_remove(*users)
      users.each do |user|
        redis.srem(redis_key, user.id)
      end
      common_broadcast
    end

    def common_broadcast
      ActionCable.server.broadcast("actb/lobby_channel", bc_action: :matching_list_broadcasted, bc_params: {matching_list_hash: matching_list_hash})
    end

    def room_create(*users)
      matching_list_remove(*users)

      # app/models/actb/room.rb
      Room.create!(rule: current_user.actb_setting.rule) do |e|
        users.each do |user|
          e.memberships.build(user: user)
        end
      end
    end

    def redis_key
      current_user.actb_setting.rule.pure_info.redis_key
    end

    def lobby_speak(message_body)
      current_user.actb_lobby_messages.create!(body: message_body)
    end
  end
end
