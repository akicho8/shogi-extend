module Actb
  class BaseChannel < ApplicationCable::Channel
    delegate :redis, to: "self.class"

    def self.redis
      @redis ||= Redis.new(db: AppConfig[:redis_db_for_actb])
    end

    def battle_user_ids
      redis.smembers(:battle_user_ids).collect(&:to_i)
    end
  end
end
