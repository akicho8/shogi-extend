module Actb
  class LobbyChannel < BaseChannel
    MATCHING_RATE_THRESHOLD_DEFAULT = 50
    MESSSAGE_LIMIT = 64

    delegate :matching_list, to: "self.class"

    def self.matching_list
      redis.smembers(:matching_list).collect(&:to_i)
    end

    ################################################################################

    def subscribed
      stream_from "actb/lobby_channel"
      common_broadcast

      if current_user
        stream_for current_user
        messages = LobbyMessage.order(:created_at).last(MESSSAGE_LIMIT)
        messages = messages.as_json(only: [:body], include: {user: {only: [:id, :key, :name], methods: [:avatar_path]}})
        LobbyChannel.broadcast_to(current_user, messages: messages)
      end
    end

    def unsubscribed
      matching_list_remove(current_user)
    end

    def speak(data)
      data = data.to_options
      current_user.actb_lobby_messages.create!(body: data[:message])
    end

    def matching_start(data)
      data = data.to_options

      matching_rate_threshold = data[:matching_rate_threshold] || MATCHING_RATE_THRESHOLD_DEFAULT

      Rails.logger.debug(ordered_infos_debug.to_t)

      if ordered_info = ordered_infos.first
        gap, opponent = ordered_info
        if gap < matching_rate_threshold
          room_create(opponent, current_user)
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
      matching_list.collect { |e| Colosseum::User.find(e) }
    end

    def matching_list_add(user)
      redis.sadd(:matching_list, user.id)
      common_broadcast
    end

    def matching_member?(user)
      redis.sismember(:matching_list, user.id)
    end

    def matching_list_remove(*users)
      users.each do |user|
        redis.srem(:matching_list, user.id)
      end
      common_broadcast
    end

    def common_broadcast
      ActionCable.server.broadcast("actb/lobby_channel", matching_list: matching_list)
    end

    def room_create(a, b)
      matching_list_remove(a, b)

      # app/models/actb/room.rb
      Room.create! do |e|
        e.memberships.build(user: a)
        e.memberships.build(user: b)
      end
    end
  end
end
