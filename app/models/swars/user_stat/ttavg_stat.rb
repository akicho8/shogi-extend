# frozen-string-literal: true

module Swars
  module UserStat
    class TtavgStat < Base
      delegate *[
        :l_scope,
      ], to: :@user_stat

      # 投了時の平均手数
      def average
        s = l_scope
        s = s.joins(:battle => :final)
        s = s.where(Final.arel_table[:key].eq("TORYO"))
        if v = s.average(Battle.arel_table[:turn_max])
          v.round
        end
      end
    end
  end
end
