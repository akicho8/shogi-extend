# frozen-string-literal: true

module Swars
  module User::Stat
    class GdiffStat < Base
      delegate *[
        :ids_scope,
      ], to: :@stat

      def average
        if v = ids_scope.average(:grade_diff)
          v.to_f.round(2)
        end
      end
    end
  end
end
