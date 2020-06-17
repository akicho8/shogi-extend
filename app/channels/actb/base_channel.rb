module Actb
  class BaseChannel < ApplicationCable::Channel
    delegate :redis, :room_user_ids, :room_user_ids_broadcast, :once_run, to: "self.class"

    class << self
      def redis
        @redis ||= Redis.new(db: AppConfig[:redis_db_for_actb])
      end

      def room_user_ids
        redis.smembers(:room_user_ids).collect(&:to_i)
      end

      def room_user_ids_broadcast
        ActionCable.server.broadcast("actb/school_channel", bc_action: :online_status_broadcasted, bc_params: {room_user_ids: room_user_ids})
      end

      def once_run(key, options = {})
        raise ArgumentError unless key

        options = {
          expires_in: 1.hours,
        }.merge(options)

        # https://qiita.com/shiozaki/items/b746dc4bb5e1e87c0528
        values = redis.multi do
          redis.incr(key)
          redis.expire(key, options[:expires_in])
        end

        counter = values.first

        Rails.logger.debug([__method__, {key: key, counter: counter, expires_in: redis.ttl(key)}])

        if block_given?
          if counter == 1
            yield
          end
        else
          counter
        end
      end
    end
  end
end
