# frozen-string-literal: true

module Swars
  module User::Stat
    class TotalJudgeStat < Base
      delegate *[
        :ids_scope,
        :ids_count,
      ], to: :stat

      def win_ratio
        @win_ratio ||= yield_self do
          win = counts_hash[:win] || 0
          lose = counts_hash[:lose] || 0
          denominator = win + lose
          if denominator.positive?
            win.fdiv(denominator)
          end
        end
      end

      def counts_hash
        @counts_hash ||= ids_scope.total_judge_counts
      end
    end
  end
end
