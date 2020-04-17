module Acns2
  class BaseChannel < ApplicationCable::Channel
    private

    def redis
      @redis ||= Redis.new(db: AppConfig[:redis_db_for_acns2])
    end
  end
end
