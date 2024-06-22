# frozen-string-literal: true

module Swars
  module User::Stat
    class TauntStat < Base
      class << self
        def search_params(final_key)
          {
            "勝敗"     => "勝ち",
            "最終思考" => [">=", threshold].join,
            "結末"     => final_key,
          }
        end

        def search_params_max(final_key)
          {
            **search_params(final_key),
            :sort_column => "membership.think_last", # FIXME: いいのか？
            :sort_order  => "desc",
          }
        end
      end

      cattr_accessor(:threshold) do
        RuleInfo[:three_min].ittezume_jirasi_sec # 45秒
      end

      delegate *[
        :ids_scope,
      ], to: :stat

      def initialize(stat, final_key)
        super(stat)
        @final_key = final_key
      end

      # 1手詰を焦らして悦に入った回数
      def count
        @count ||= scope.count
      end

      # 1手詰を焦らして悦に入った時間(最長)
      def max
        @max ||= yield_self do
          if count.positive?
            scope.maximum(:think_last)
          end
        end
      end

      # 1手詰を焦らして悦に入った頻度
      def to_chart
        @to_chart ||= yield_self do
          if count.positive?
            s = scope
            h = s.group("think_last DIV 60").order("count_all DESC").count
            if h.present?
              h.collect do |min, count|
                if min.zero?
                  name = "#{threshold}秒" # 以上
                else
                  name = "#{min}分"
                end
                { name: name, value: count }
              end
            end
          end
        end
      end

      private

      def scope
        s = ids_scope.win_only
        s = s.where(Membership.arel_table[:think_last].gteq(threshold))
        s = s.joins(:battle => :final)
        s = s.where(Final.arel_table[:key].eq(@final_key))
      end
    end
  end
end
