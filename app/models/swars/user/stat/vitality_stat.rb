# frozen-string-literal: true

module Swars
  module User::Stat
    class VitalityStat < Base
      PERIOD_DAYS        = 5 # 直近N日を対象とする (が、ids_count (50) 以上は含まれないため最大 15 日ぐらいまでとする)
      FREE_BATTLE_COUNT  = 3 # 無料で3局指せる (つまり1日3局指し続けていれば 100% とする)

      include TimeMod

      delegate *[
        :ids_scope,
      ], to: :stat

      def badge?
        level > 1.0
      end

      # 最近の1日あたりの対局数 = 勢い
      def level
        @level ||= count.fdiv(FREE_BATTLE_COUNT * PERIOD_DAYS)
      end

      # 最近の対局数
      def count
        @count ||= yield_self do
          s = ids_scope
          s = s.joins(:battle)
          s = s.where(Battle.arel_table[:battled_at].gteq(PERIOD_DAYS.days.ago))
          s.count
        end
      end
    end
  end
end
