# frozen-string-literal: true

module Swars
  module User::Stat
    class TurnStat < Base
      delegate *[
        :ids_scope,
      ], to: :@stat

      def initialize(stat, scope)
        super(stat)
        @scope = scope
      end

      # 最大手数
      def max
        @max ||= scope.maximum(Battle.arel_table[:turn_max])
      end

      # 平均手数
      def average
        @average ||= yield_self do
          if max
            scope.average(Battle.arel_table[:turn_max]).round
          end
        end
      end

      private

      def scope
        s = @scope
        s = s.joins(:battle)
      end
    end
  end
end
