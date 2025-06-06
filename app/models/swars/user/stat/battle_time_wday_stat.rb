# frozen-string-literal: true

module Swars
  module User::Stat
    class BattleTimeWdayStat < Base
      include TimeMod

      delegate *[
        :ids_scope,
        :ids_count,
      ], to: :stat

      def to_chart
        if ids_count.positive?
          hv = ids_scope.joins(:battle).group("DAYOFWEEK(#{dawn_adjusted_battled_at})").count
          WdayInfo.collect do |e|
            { name: e.name, value: hv.fetch(e.dayofweek, 0).fdiv(ids_count) }
          end
        end
      end
    end
  end
end
