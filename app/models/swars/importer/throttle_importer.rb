module Swars
  module Importer
    class ThrottleImporter < Base
      def default_params
        {
          interval: default_interval,
        }
      end

      def call
        if params[:throttle_cache_clear]
          Rails.cache.delete(cache_key)
        end
        if Rails.cache.exist?(cache_key)
          return false
        end
        Rails.cache.write(cache_key, true, expires_in: params[:interval])
        FullHistoryImporter.new(params).call
        true
      end

      private

      def cache_key
        @cache_key ||= [
          self.class.name,
          params[:user_key],
          params[:page_max],
        ].join("/")
      end

      def default_interval
        Rails.env.local? ? 10.seconds : 3.minutes
      end
    end
  end
end
