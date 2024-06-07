# frozen-string-literal: true

module Swars
  module User::Stat
    class MatchTimePeriodStat < Base
      delegate *[
        :ids_scope,
      ], to: :@stat

      def to_chart
        ids = ids_scope.pluck(:battle_id)
        if ids.present?
          s = Battle.where(id: ids)
          hv = s.group("HOUR(#{battled_at})").count
          hour_range.collect do |hour|
            { name: hour.to_s, value: hv[hour] || 0 }
          end
        end
      end

      private

      def battled_at
        MysqlUtil.column_tokyo_timezone_cast(:battled_at)
      end

      # 深夜と早朝の間を境界にする
      def hour_range
        [*4..23, *0..3]
      end
    end
  end
end
