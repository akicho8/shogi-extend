# frozen-string-literal: true

module Swars
  module User::Stat
    class PerpetualCheckStat < Base
      delegate *[
        :ids_scope,
        :draw_count,
        :draw_only,
      ], to: :@stat

      # 開幕千日手回数
      def opening_repetition_move_count
        @opening_repetition_move_count ||= yield_self do
          if draw_count.positive?
            s = draw_only
            s = s.joins(:battle).where(Battle.arel_table[:turn_max].eq(12))
            s.count
          end
        end
      end

      # 引き分け数 (50手以上)
      def over50_draw_count
        @over50_draw_count ||= yield_self do
          if draw_count.positive?
            s = draw_only
            s = s.joins(:battle).where(Battle.arel_table[:turn_max].gteq(50))
            s.count
          end
        end
      end
    end
  end
end
