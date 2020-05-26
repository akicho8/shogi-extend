module Actb
  class BaseChannel < ApplicationCable::Channel
    delegate :redis, :room_user_ids, :room_user_ids_broadcast, to: "self.class"

    class << self
      def redis
        @redis ||= Redis.new(db: AppConfig[:redis_db_for_actb])
      end

      def room_user_ids
        redis.smembers(:room_user_ids).collect(&:to_i)
      end

      def room_user_ids_broadcast
        ActionCable.server.broadcast("actb/school_channel", room_user_ids: room_user_ids)
      end
    end
  end
end
