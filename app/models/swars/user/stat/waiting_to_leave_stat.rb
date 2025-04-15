# frozen-string-literal: true

module Swars
  module User::Stat
    class WaitingToLeaveStat < Base
      class << self
        # 一致していない
        def search_params
          {
            "勝敗"     => "負け",
            "手数"     => [">=", Config.seiritsu_gteq].join,
            "最大思考" => [">=", threshold].join,
          }
        end
      end

      cattr_accessor(:threshold) do
        RuleInfo[:ten_min].taisekimati_sec
      end

      delegate *[
        :ids_scope,
      ], to: :stat

      # 相手退席待ち数
      def count
        @count ||= yield_self do
          s = ids_scope.lose_only
          s = s.where(Membership.arel_table[:think_last].not_eq(nil))                               # 最後の考量がある
          s = s.where(Membership.arel_table[:think_max].not_eq(Membership.arel_table[:think_last])) # 長考は最後ではない
          s = s.where(Membership.arel_table[:think_max].gteq(threshold))                            # 異常な長考がある
          s = s.joins(:battle)
          s = s.where(Battle.arel_table[:turn_max].gteq(Config.seiritsu_gteq))
          s.count
        end
      end
    end
  end
end
