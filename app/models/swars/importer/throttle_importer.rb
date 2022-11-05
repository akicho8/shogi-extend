module Swars
  module Importer
    class ThrottleImporter
      attr_accessor :params

      def initialize(params = {})
        @params = {
          seconds: default_interval,
        }.merge(params)
      end

      def run
        if params[:force]
          throttle_user_import_cache_delete
        end

        # キャッシュの有効時間のみ利用して連続実行を防ぐ
        if Rails.cache.exist?(cache_key)
          return false
        end
        Rails.cache.write(cache_key, true, expires_in: params[:seconds])

        AllRuleImporter.new(params).run
        true
      end

      private

      def throttle_user_import_cache_delete
        Rails.cache.delete(cache_key)
      end

      def cache_key
        @cache_key ||= [self.class.name, params[:user_key], params[:page_max]].join("/")
      end

      def default_interval
        if Rails.env.development? || Rails.env.test?
          return 10.seconds
        end

        3.minutes
      end
    end
  end
end
