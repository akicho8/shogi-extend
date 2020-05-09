module Actf
  class BaseChannel < ApplicationCable::Channel
    delegate :redis, to: "self.class"

    def self.redis
      @redis ||= Redis.new(db: AppConfig[:redis_db_for_actf])
    end

    def room_user_ids
      redis.smembers(:room_user_ids).collect(&:to_i)
    end
  end
end
