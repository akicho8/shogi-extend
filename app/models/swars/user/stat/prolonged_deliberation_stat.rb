# frozen-string-literal: true

module Swars
  module User::Stat
    class ProlongedDeliberationStat < Base
      class << self
        def search_params
          {
            "開始モード" => "通常",
            "最大思考"   => [">=", threshold].join,
          }
        end
      end

      cattr_accessor(:threshold) do
        RuleInfo[:ten_min].kangaesugi_like_houti_sec
      end

      delegate *[
        :ids_scope,
      ], to: :stat

      # 放置かと思うような大長考 (勝ち負け関係なし)
      def count
        @count ||= yield_self do
          s = ids_scope
          s = s.joins(:battle => :imode)
          s = s.where(Imode.arel_table[:key].eq(:normal))
          s = s.where(Membership.arel_table[:think_max].gteq(threshold))
          s.count
        end
      end
    end
  end
end
