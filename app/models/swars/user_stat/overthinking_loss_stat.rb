# frozen-string-literal: true

module Swars
  module UserStat
    class OverthinkingLossStat < Base
      delegate *[
        :ids_scope,
        :lose_count,
      ], to: :@user_stat

      # 長考マン: 考えすぎて負けがち
      def medal?
        (ratio || 0) > 0.1
      end

      def ratio
        if lose_count.positive?
          count.fdiv(lose_count)
        end
      end

      def count
        @count ||= yield_self do
          s = ids_scope.lose_only
          s = s.where(Membership.arel_table[:think_max].between(range))
          s.count
        end
      end

      def range
        a = RuleInfo[:ten_min].kangaesugi_sec            # 2.5 min
        b = RuleInfo[:ten_min].kangaesugi_like_houti_sec # 3.0 min
        a...b
      end
    end
  end
end
