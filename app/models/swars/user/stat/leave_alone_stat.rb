# frozen-string-literal: true

module Swars
  module User::Stat
    class LeaveAloneStat < Base
      class << self
        def search_params
          {
            "勝敗"     => "負け",
            "結末"     => "時間切れ",
            "最終思考" => [">=", RuleInfo[:ten_min].toryo_houti_sec].join,
          }
        end

        def search_params_max
          {
            **search_params,
            :sort_column => "membership.think_last",
            :sort_order  => "desc",
          }
        end
      end

      delegate *[
        :ids_scope,
      ], to: :stat

      # 投了せずに放置した時間の最長
      def max
        @max ||= yield_self do
          if count.positive?
            scope.maximum(:think_last)
          end
        end
      end

      # 投了せずに放置した頻度
      def to_chart
        if count.positive?
          h = scope.group("think_last DIV 60").order("count_all DESC").count
          h.collect do |min, count|
            { name: "#{min}分", value: count }
          end
        end
      end

      # 投了せずに放置した回数
      def count
        @count ||= scope.count
      end

      private

      def scope
        s = ids_scope.lose_only
        s = s.joins(:battle => :final)
        s = s.where(Final.arel_table[:key].eq(:TIMEOUT))
        s = s.where(Membership.arel_table[:think_last].gteq(RuleInfo[:ten_min].toryo_houti_sec))
      end
    end
  end
end
