# frozen-string-literal: true

module Swars
  module UserStat
    class MspeedStat < Base
      delegate *[
        :w_scope,
      ], to: :@user_stat

      # 詰ます速度 (1手平均)
      def average
        s = w_scope
        s = s.joins(:battle => :final)
        s = s.where(Final.arel_table[:key].eq(:CHECKMATE))
        if v = s.average(:think_end_avg)
          v.to_f.round(2)
        end
      end
    end
  end
end
