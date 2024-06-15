# frozen-string-literal: true

module Swars
  module User::Stat
    class TemplateStat < Base
      class << self
        def report(options = {})
          User::Vip.auto_crawl_user_keys.collect { |user_key|
            if user = User[user_key]
              template_stat = user.stat(options).template_stat
              {
                :user_key => user.key,
                :count    => template_stat.count,
              }
            end
          }.compact.sort_by { |e| e[:count] }
        end
      end

      delegate *[
        :ids_scope,
      ], to: :stat

      def count
        @count ||= ids_scope.count
      end
    end
  end
end
