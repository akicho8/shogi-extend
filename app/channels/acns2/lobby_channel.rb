class Acns2::LobbyChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, current_user&.name])
    stream_from "acns2/lobby_channel"
    ActionCable.server.broadcast("acns2/lobby_channel", matching_set: matching_set)
  end

  def unsubscribed
    Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, current_user&.name])
    # Any cleanup needed when channel is unsubscribed

    redis.srem("matching_set", current_user.id)
  end

  def matching_start(data)
    Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, matching_set])

    case
    when redis.sismember("matching_set", current_user.id)
    when redis.scard("matching_set") == 0
      redis.sadd("matching_set", current_user.id)
    else
      if id = redis.spop("matching_set")
        op_user = Colosseum::User.find(id)
        Acns2::Room.create! do |e|
          e.memberships.build(user: op_user)
          e.memberships.build(user: current_user)
        end
        # --> app/jobs/acns2/lobby_broadcast_job.rb
      end
    end

    ActionCable.server.broadcast("acns2/lobby_channel", matching_set: matching_set)

    # Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, data, current_user])
    # Acns2::Message.create!(body: data['message'], user: current_user, room_id: params['room_id'])
  end

  def matching_cancel(data)
    redis.srem("matching_set", current_user.id)
    ActionCable.server.broadcast("acns2/lobby_channel", matching_set: matching_set)
  end

  private

  def matching_set
    redis.smembers("matching_set")
  end

  def redis
    @redis ||= Redis.new(db: AppConfig[:redis_db_for_acns2])
  end
end
