# frozen-string-literal: true

module Swars
  module User::Stat
    class VitalityStat < Base
      PERIOD_DAYS       = 5     # 直近N日を対象とする (が、ids_count (50) 以上は含まれないため最大 15 日ぐらいまでとする)
      FREE_BATTLE_COUNT = 3     # 無料で3局指せる (つまり1日3局指し続けていれば 100% とする)

      delegate *[
        :ids_scope,
      ], to: :stat

      # 勢いがある・勝率5割越え
      def vital_and_strong?
        vital_ratio > 1.0 && win_ratio > 0.5
      end

      # 勢いがある・勝率5割以下
      def vital_but_weak?
        vital_ratio > 1.0 && win_ratio <= 0.5
      end

      # 最近の1日あたりの対局数 = 勢い
      def vital_ratio
        @vital_ratio ||= count.fdiv(FREE_BATTLE_COUNT * PERIOD_DAYS)
      end

      private

      ################################################################################

      # 最近の勝ち
      def win_only
        @win_only ||= local_scope.win_only
      end

      # 最近の勝数
      def win_count
        @win_count ||= win_only.count
      end

      # 最近の勝率
      def win_ratio
        @win_ratio ||= yield_self do
          if count.positive?
            win_count.fdiv(count)
          else
            0.0
          end
        end
      end

      ################################################################################

      # 最近の対局たち
      def local_scope
        @local_scope ||= yield_self do
          s = ids_scope
          s = s.joins(:battle)
          s = s.where(Battle.arel_table[:battled_at].gteq(PERIOD_DAYS.days.ago))
        end
      end

      # 最近の対局数
      def count
        @count ||= local_scope.count
      end

      ################################################################################
    end
  end
end
