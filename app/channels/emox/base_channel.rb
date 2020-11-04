module Emox
  class BaseChannel < ApplicationCable::Channel
    delegate :redis, :once_run, :already_run?, to: "self.class"

    class << self
      def redis
        @redis ||= Redis.new(db: AppConfig[:redis_db_for_emox])
      end

      def redis_clear
        redis.flushdb
      end

      # if Emox::BaseChannel.once_run("shared key", expires_in: 1.minute)
      #   ...
      # end
      def once_run(key, options = {})
        raise ArgumentError unless key

        if key.kind_of? Array
          raise ArgumentError unless key.flatten.all?
          key = key.join("/")
        end

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

        counter == 1
      end

      def already_run?(key, options = {})
        !once_run(key, options)
      end
    end
  end
end
