# frozen-string-literal: true

module Swars
  module User::Stat
    class RuleStat < Base
      delegate *[
        :ids_scope,
      ], to: :@stat

      # ルール別対局頻度
      def to_chart
        @to_chart ||= yield_self do
          counts = ids_scope.joins(:battle => :rule).group("swars_rules.key").count
          if counts.present?
            Swars::RuleInfo.collect do |e|
              {
                :name  => e.name,
                :value => counts[e.key.to_s] || 0,
              }
            end
          end
        end
      end
    end
  end
end
