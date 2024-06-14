# frozen-string-literal: true

module Swars
  module User::Stat
    class ThinkStat < Base
      class << self
        def report(options = {})
          Swars::User::Vip.auto_crawl_user_keys.collect { |user_key|
            if user = Swars::User[user_key]
              think_stat = user.stat(options).think_stat
              {
                :user_key             => user.key,
                :average              => think_stat.average.try { round(2) },
                :unusually_slow_ratio => think_stat.unusually_slow_ratio.try { round(2) },
                :unusually_fast_ratio => think_stat.unusually_fast_ratio.try { round(2) },
              }
            end
          }.compact.sort_by { |e| -e[:average].to_f }
        end
      end

      delegate *[
        :ids_scope,
      ], to: :@stat

      # 最大思考
      def max
        @max ||= ids_scope.maximum(:think_max)
      end

      # 平均思考
      def average
        @average ||= ids_scope.average(:think_all_avg)&.to_f
      end

      # 指し手が異常に遅い度合い
      def unusually_slow_ratio
        @unusually_slow_ratio ||= yield_self do
          if average
            ab = 10.0..14.0
            if average >= ab.min
              map_range(average, *ab.minmax, 0.0, 1.0)
            end
          end
        end
      end

      # 指し手が異常に速い度合い
      def unusually_fast_ratio
        @unusually_fast_ratio ||= yield_self do
          if average
            ab = 1.5..2.0
            if average <= ab.max
              map_range(average, *ab.minmax, 1.0, 0.0)
            end
          end
        end
      end
    end
  end
end
