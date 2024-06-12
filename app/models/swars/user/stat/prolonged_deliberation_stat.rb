# frozen-string-literal: true

module Swars
  module User::Stat
    class ProlongedDeliberationStat < Base
      delegate *[
        :ids_scope,
      ], to: :@stat

      def positive_count
        if count.positive?
          count
        end
      end

      # 放置かと思うような大長考 (勝ち負け関係なし)
      def count
        @count ||= yield_self do
          s = ids_scope
          s = s.where(Membership.arel_table[:think_max].gteq(threshold))
          s.count
        end
      end

      def threshold
        RuleInfo[:ten_min].kangaesugi_like_houti_sec
      end
    end
  end
end
