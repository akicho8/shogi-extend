# frozen-string-literal: true

module Swars
  module UserStat
    class TzoneStat < Base
      delegate *[
        :ids_scope,
      ], to: :@user_stat

      def to_chart
        ids = ids_scope.pluck(:battle_id)
        if ids.present?
          casted_battled_at = MysqlUtil.column_tokyo_timezone_cast(:battled_at)
          s = Battle.where(id: ids)
          hv = s.group("HOUR(#{casted_battled_at})").count
          hour_range.collect do |hour|
            { name: hour.to_s, value: hv[hour] || 0 }
          end
        end
      end

      private

      # 深夜と早朝の間を境界にする
      def hour_range
        [*4..23, *0..3]
      end
    end
  end
end
