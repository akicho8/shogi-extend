# frozen-string-literal: true

module Swars
  module User::Stat
    class AverageMovesAtResignationStat < Base
      delegate *[
        :ids_scope,
      ], to: :@stat

      # 投了時の平均手数
      def average
        s = ids_scope.lose_only
        s = s.joins(:battle => :final)
        s = s.where(Final.arel_table[:key].eq("TORYO"))
        if v = s.average(Battle.arel_table[:turn_max])
          v.round
        end
      end
    end
  end
end
