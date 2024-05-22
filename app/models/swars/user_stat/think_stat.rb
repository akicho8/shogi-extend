# frozen-string-literal: true

module Swars
  module UserStat
    class ThinkStat < Base
      delegate *[
        :ids_scope,
      ], to: :@user_stat

      # 最大思考
      def max
        @max ||= scope.maximum(:think_max)
      end

      # 平均思考
      def average
        @average ||= yield_self do
          if v = scope.average(:think_all_avg)
            v.to_f.round(2)
          end
        end
      end

      private

      def scope
        ids_scope
      end
    end
  end
end
