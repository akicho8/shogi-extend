# frozen-string-literal: true

module Swars
  module User::Stat
    class GdiffStat < Base
      delegate *[
        :ids_scope,
        :ids_count,
      ], to: :@stat

      def formated_average
        @formated_average ||= yield_self do
          if ids_count.positive?
            average.round(2)
          end
        end
      end

      def average
        @average ||= ids_scope.average(:grade_diff).to_f
      end

      def abs
        @abs ||= average.abs
      end
    end
  end
end
