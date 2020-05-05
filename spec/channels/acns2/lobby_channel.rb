module Acns2
  class LobbyChannel < BaseChannel
    def subscribed
      stream_from "acns2/lobby_channel"
      common_broadcast
    end

    def unsubscribed
      if current_user
        redis.srem(:matching_list, current_user.id)
      end
      common_broadcast
    end

    def matching_start(data)
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

      common_broadcast
    end

    def matching_cancel(data)
      redis.srem(:matching_list, current_user.id)
      common_broadcast
    end

    private

    def matching_list
      redis.smembers(:matching_list)
    end

    def common_broadcast
      ActionCable.server.broadcast("acns2/lobby_channel", matching_list: matching_list)
    end
  end
end
