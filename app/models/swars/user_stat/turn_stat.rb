# frozen-string-literal: true

module Swars
  module UserStat
    class TurnStat < Base
      delegate *[
        :ids_scope,
      ], to: :@user_stat

      def initialize(user_stat, scope)
        super(user_stat)
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
