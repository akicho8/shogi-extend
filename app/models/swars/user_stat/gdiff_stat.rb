# frozen-string-literal: true

module Swars
  module UserStat
    class GdiffStat < Base
      delegate *[
        :ids_scope,
      ], to: :@user_stat

      def average
        if v = ids_scope.average(:grade_diff)
          v.to_f.round(2)
        end
      end
    end
  end
end
