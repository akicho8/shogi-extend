# frozen-string-literal: true

module Swars
  module User::Stat
    class SkillAdjustStat < Base
      delegate *[
        :ids_scope,
      ], to: :stat

      def exist?
        count.positive?
      end

      def count
        @count ||= yield_self do
          s = ids_scope.lose_only
          s = s.joins(:battle => :final)
          s = s.where(Final.arel_table[:key].eq_any([:TORYO, :CHECKMATE]))
          s = s.where(Battle.arel_table[:turn_max].lt(Config.seiritsu_gteq))
          s.count
        end
      end
    end
  end
end
