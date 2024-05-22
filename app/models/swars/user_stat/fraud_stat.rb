# frozen-string-literal: true

module Swars
  module UserStat
    class FraudStat < Base
      delegate *[
        :ids_scope,
        :ids_count,
      ], to: :@user_stat

      # 棋神を使って対局した数
      def count
        @count ||= ids_scope.fraud_only.count
      end

      def to_chart
        @to_chart ||= yield_self do
          if count.positive?
            [
              { name: "有り", value: count,             },
              { name: "無し", value: ids_count - count, },
            ]
          end
        end
      end
    end
  end
end
