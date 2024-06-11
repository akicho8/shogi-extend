# frozen-string-literal: true

module Swars
  module User::Stat
    class DrawStat < Base
      RIGGING_TURN_MAX = 12

      delegate *[
        :ids_scope,
        :draw_count,
        :draw_only,
      ], to: :@stat

      def positive_rigging_count
        if (v = rigging_count) && v > 0
          v
        end
      end

      def positive_normal_count
        if (v = normal_count) && v > 0
          v
        end
      end

      def positive_bad_count
        if (v = bad_count) && v > 0
          v
        end
      end

      # 開幕千日手回数 (談合)
      def rigging_count
        @rigging_count ||= yield_self do
          if draw_count.positive?
            s = draw_only
            s = s.joins(:battle).where(Battle.arel_table[:turn_max].eq(RIGGING_TURN_MAX))
            s.count
          end
        end
      end

      # 一般的な千日手回数
      def normal_count
        @normal_count ||= yield_self do
          if draw_count.positive?
            s = draw_only
            s = s.joins(:battle).where(Battle.arel_table[:turn_max].gt(RIGGING_TURN_MAX))
            s.count
          end
        end
      end

      # 先手なのに千日手にした回数
      def bad_count
        @bad_count ||= yield_self do
          if draw_count.positive?
            s = draw_only
            s = s.joins(:battle).where(Battle.arel_table[:turn_max].gt(RIGGING_TURN_MAX))
            s = s.joins(:location).where(Location.arel_table[:key].eq(:black))
            s.count
          end
        end
      end
    end
  end
end
