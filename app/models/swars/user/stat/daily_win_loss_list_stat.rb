# frozen-string-literal: true

# _ { Swars::User["SugarHuuko"].stat.daily_win_loss_list_stat.to_chart_slow }   # => "94.66 ms"
# _ { Swars::User["SugarHuuko"].stat.daily_win_loss_list_stat.to_chart      }   # => "22.69 ms"

module Swars
  module User::Stat
    class DailyWinLossListStat < Base
      delegate *[
        :ids_scope,
      ], to: :@stat

      # 日別勝敗リスト
      def to_chart
        s = ids_scope
        s = s.joins(:battle)
        s = s.select([
            "DATE(#{battled_at}) AS battled_on",
            "COUNT(judge_id = #{Judge[:win].id}  OR NULL) AS win",
            "COUNT(judge_id = #{Judge[:lose].id} OR NULL) AS lose",
          ])
        s = s.order("battled_on DESC")
        s = s.group("battled_on")
        s.collect do |e|
          battled_on = e.battled_on.to_date
          {
            :battled_on   => battled_on,
            :day_type     => day_type_for(battled_on),
            :judge_counts => { win: e.win, lose: e.lose },
          }
        end
      end

      private

      def battled_at
        MysqlUtil.column_tokyo_timezone_cast(:battled_at)
      end

      def day_type_for(t)
        case
        when t.sunday?
          :danger
        when t.saturday?
          :info
        when HolidayJp.holiday?(t)
          :danger
        end
      end
    end
  end
end
