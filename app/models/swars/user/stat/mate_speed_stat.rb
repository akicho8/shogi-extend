# frozen-string-literal: true

module Swars
  module User::Stat
    class MateSpeedStat < Base
      delegate *[
        :ids_scope,
      ], to: :stat

      # 詰ます速度 (1手平均)
      def average
        s = ids_scope.win_only
        s = s.joins(:battle => :final)
        s = s.where(Final.arel_table[:key].eq(:CHECKMATE))
        if v = s.average(:think_end_avg)
          v.to_f.round(2)
        end
      end
    end
  end
end
