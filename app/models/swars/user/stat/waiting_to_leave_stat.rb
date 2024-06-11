# frozen-string-literal: true

module Swars
  module User::Stat
    class WaitingToLeaveStat < Base
      delegate *[
        :ids_scope,
      ], to: :@stat

      def positive_count
        if count.positive?
          count
        end
      end

      # 相手退席待ち数
      def count
        @count ||= yield_self do
          s = ids_scope.lose_only
          s = s.where(Membership.arel_table[:think_last].not_eq(nil))                               # 最後の考慮がある
          s = s.where(Membership.arel_table[:think_max].not_eq(Membership.arel_table[:think_last])) # 最長考は最後ではない
          s = s.where(Membership.arel_table[:think_max].gteq(threshold))                            # 最後ではないところで長考がある
          s = s.joins(:battle)
          s = s.where(Battle.arel_table[:turn_max].gteq(14))
          s.count
        end
      end

      def threshold
        RuleInfo[:ten_min].taisekimati_sec
      end
    end
  end
end
