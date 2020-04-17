module Acns2
  # class LobbyChannel < ApplicationCable::Channel
  class LobbyChannel < BaseChannel
    def subscribed
      Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, current_user&.name])
      stream_from "acns2/lobby_channel"

      if current_user
        redis.sadd(:online_user_ids, current_user.id)
      end
      broadcast_matching_set_and_online_user_ids
    end

    def unsubscribed
      Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, current_user&.name])
      # Any cleanup needed when channel is unsubscribed

      if current_user
        redis.srem(:online_user_ids, current_user.id)
        redis.srem(:matching_list, current_user.id)
      end

      broadcast_matching_set_and_online_user_ids
    end

    def matching_start(data)
      Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, matching_list])

      case
      when redis.sismember(:matching_list, current_user.id)
      when redis.scard(:matching_list) == 0
        redis.sadd(:matching_list, current_user.id)
      else
        if id = redis.spop(:matching_list) # shuffle.pop 相当
          op_user = Colosseum::User.find(id)
          Room.create! do |e|
            e.memberships.build(user: op_user)
            e.memberships.build(user: current_user)
          end
          # --> app/jobs/acns2/lobby_broadcast_job.rb
        end
      end

      ActionCable.server.broadcast("acns2/lobby_channel", matching_list: matching_list)

      # Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, data, current_user])
      # Message.create!(body: data['message'], user: current_user, room_id: params['room_id'])
    end

    def matching_cancel(data)
      redis.srem(:matching_list, current_user.id)
      ActionCable.server.broadcast("acns2/lobby_channel", matching_list: matching_list)
    end

    private

    def matching_list
      redis.smembers(:matching_list)
    end

    def online_user_ids
      redis.smembers(:online_user_ids)
    end

    def broadcast_matching_set_and_online_user_ids
      ActionCable.server.broadcast("acns2/lobby_channel", matching_list: matching_list, online_user_ids: redis.smembers(:online_user_ids))
    end
  end
end
