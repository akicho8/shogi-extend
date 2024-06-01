# frozen-string-literal: true

# _ { Swars::User["SugarHuuko"].user_stat.daily_win_loss_list_stat.to_chart_slow }   # => "94.66 ms"
# _ { Swars::User["SugarHuuko"].user_stat.daily_win_loss_list_stat.to_chart      }   # => "22.69 ms"

module Swars
  module UserStat
    class DailyWinLossListStat < Base
      delegate *[
        :ids_scope,
      ], to: :@user_stat

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

      # 昔の方法 (遅い)
      def to_chart_slow
        judge_counts_of = -> memberships {
          group = memberships.group_by(&:judge_key)
          ["win", "lose"].each_with_object({}) { |e, m| m[e] = (group[e] || []).count }
        }
        group = ids_scope.joins(:battle).order(Battle.arel_table[:battled_at].desc).group_by { |e| e.battle.battled_at.midnight }
        group.collect do |battled_at, memberships|
          hv = {}
          hv[:battled_on]   = battled_at.to_date
          hv[:day_type]     = day_type_for(battled_at)
          hv[:judge_counts] = judge_counts_of[memberships]
          # hv[:all_tags]     = nil   # ← 設定すればビュー側で出る
          hv
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
