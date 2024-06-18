# frozen-string-literal: true

module Swars
  module User::Stat
    class BattleTimeHourStat < Base
      include TimeMod

      delegate *[
        :ids_scope,
      ], to: :stat

      def to_chart
        hv = ids_scope.joins(:battle).group("HOUR(#{zero_adjusted_battled_at})").count
        day_hours.collect do |hour|
          { name: hour.to_s, value: hv.fetch(hour, 0) }
        end
      end
    end
  end
end
