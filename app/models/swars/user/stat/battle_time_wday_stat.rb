# frozen-string-literal: true

module Swars
  module User::Stat
    class BattleTimeWdayStat < Base
      delegate *[
        :ids_scope,
        :ids_count,
      ], to: :stat

      def to_chart
        hv = ids_scope.joins(:battle).group("DAYOFWEEK(DATE_SUB(#{battled_at}, INTERVAL #{BattleTimeHourStat::DAY_START_HOUR} HOUR))").count
        WdayInfo.collect do |e|
          { name: e.name, value: hv.fetch(e.odbc_code, 0).fdiv(ids_count) }
        end
      end

      private

      def battled_at
        MysqlUtil.column_tokyo_timezone_cast(:battled_at)
      end
    end
  end
end
