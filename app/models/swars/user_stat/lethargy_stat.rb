# frozen-string-literal: true

module Swars
  module UserStat
    class LethargyStat < Base
      delegate *[
        :lose_count,
        :ids_scope,
      ], to: :@user_stat

      def exist?
        (count || 0).positive?
      end

      def positive_count
        if exist?
          count
        end
      end

      def count
        @count ||= yield_self do
          if lose_count.positive?
            s = ids_scope.lose_only
            s = s.joins(:battle => :final)
            s = s.where(Final.arel_table[:key].eq_any(["TORYO", "CHECKMATE"]))
            s = s.where(Battle.arel_table[:turn_max].lteq(19))
            s.count
          end
        end
      end
    end
  end
end
