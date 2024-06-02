# frozen-string-literal: true

module Swars
  module UserStat
    class MateStat < Base
      delegate *[
        :ids_scope,
      ], to: :@user_stat

      # 1手詰を焦らして悦に入った回数
      def positive_count
        if count.positive?
          count
        end
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
            h = s.group("think_last DIV 60").order("count_all desc").count
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

      def count
        @count ||= scope.count
      end

      private

      def threshold
        RuleInfo[:three_min].ittezume_jirasi_sec # 45秒
      end

      def scope
        s = ids_scope.win_only
        s = s.where(Membership.arel_table[:think_last].gteq(threshold))
        s = s.joins(:battle => :final)
        s = s.where(Final.arel_table[:key].eq("CHECKMATE"))
      end
    end
  end
end
