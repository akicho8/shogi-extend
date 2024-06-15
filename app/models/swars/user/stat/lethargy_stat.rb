# frozen-string-literal: true

module Swars
  module User::Stat
    class LethargyStat < Base
      delegate *[
        :ids_scope,
      ], to: :stat

      def exist?
        count.positive?
      end

      # 無気力な対局をした回数 (不自然に多い場合は故意に棋力を落としている場合もある)
      # ほぼ100%の人が一度は負けているので lose_count.positive? で囲む効果はない
      def count
        @count ||= yield_self do
          s = ids_scope.lose_only
          s = s.joins(:battle => :final)
          s = s.where(Final.arel_table[:key].eq_any([:TORYO, :CHECKMATE]))
          s = s.where(Battle.arel_table[:turn_max].lteq(19))
          s.count
        end
      end
    end
  end
end
