module ApplicationCable
  class Channel < ActionCable::Channel::Base
    delegate :redis, :once_run, :already_run?, to: "self.class"

    class << self
      def redis_db_index
        raise NotImplementedError, "#{__method__} is not implemented"
      end

      def redis
        @redis ||= Redis.new(db: redis_db_index)
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

    def __event_notify__(method_name, params = {})
      return if Rails.env.production? || Rails.env.test?

      body = []
      body << "[#{Time.current.to_s(:ymdhms)}]"
      if current_user
        body << "[#{current_user.id}][#{current_user.name}]"
      end
      body << " "
      body << params.inspect

      if ENV["ACTION_CABLE_SLACK_NOTIFY"]
        SlackAgent.message_send(key: "#{self.class.name}##{method_name}", body: body.join)
      end
    end
  end
end
