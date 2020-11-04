module Actb
  class BaseChannel < ApplicationCable::Channel
    class << self
      def redis_db_index
        AppConfig.fetch(:redis_db_for_actb)
      end
    end
  end
end
