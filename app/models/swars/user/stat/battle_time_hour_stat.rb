# frozen-string-literal: true

module Swars
  module User::Stat
    class BattleTimeHourStat < Base
      DAY_START_HOUR = 4

      delegate *[
        :ids_scope,
        :ids_count,
      ], to: :stat

      def to_chart
        hv = ids_scope.joins(:battle).group("HOUR(#{battled_at})").count
        hours.collect do |hour|
          { name: hour.to_s, value: hv.fetch(hour, 0) }
        end
      end

      private

      # 深夜と早朝の間を境界にする
      def hours
        [*DAY_START_HOUR..23, *0..DAY_START_HOUR.pred]
      end

      def battled_at
        MysqlUtil.column_tokyo_timezone_cast(:battled_at)
      end
    end
  end
end
