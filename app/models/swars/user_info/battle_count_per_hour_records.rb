module Swars
  module UserInfo
    class BattleCountPerHourRecords
      def initialize(user_info)
        @user_info = user_info
      end

      def to_chart
        ids = @user_info.ids_scope.pluck(:battle_id)
        if ids.present?
          casted_battled_at = MysqlUtil.tz_adjust("battled_at")
          s = Battle.where(id: ids)
          counts_hash = s.group("HOUR(#{casted_battled_at})").count
          hour_range.collect do |hour|
            { name: hour.to_s, value: counts_hash[hour] || 0 }
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
