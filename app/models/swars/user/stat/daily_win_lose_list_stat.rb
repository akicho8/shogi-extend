# frozen-string-literal: true

module Swars
  module User::Stat
    class DailyWinLoseListStat < Base
      include TimeMod

      delegate *[
        :ids_scope,
      ], to: :stat

      # 日別勝敗リスト
      # judge_id ではなく JOIN して judges.key で比較した方が速い "4.39 ms" → "2.83 ms"
      def to_chart
        s = ids_scope
        s = s.joins(:battle)
        s = s.joins(:judge)
        s = s.select([
            "DATE(#{dawn_adjusted_battled_at}) AS battled_on",
            "COUNT(judges.key = 'win'  OR NULL) AS win",
            "COUNT(judges.key = 'lose' OR NULL) AS lose",
          ])
        s = s.where.not(Judge.arel_table[:key].eq(:draw))
        s = s.order("battled_on DESC")
        s = s.group("battled_on")
        s.collect do |e|
          battled_on = e.battled_on.to_date
          {
            :battled_on   => battled_on,
            :day_type     => date_to_day_type(battled_on),
            :judge_counts => { win: e.win, lose: e.lose },
          }
        end
      end
    end
  end
end
