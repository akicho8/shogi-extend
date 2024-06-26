# frozen-string-literal: true

module Swars
  module User::Stat
    class RecentOutcomeListStat < Base
      delegate *[
        :params,
        :ordered_ids_scope,
      ], to: :stat

      # 直近勝敗リスト
      def to_a
        @to_a ||= ordered_ids_scope.limit(max).s_pluck_judge_key.reverse
      end

      private

      def max
        @max ||= [(params[:ox_max].presence || 17).to_i, 100].min
      end
    end
  end
end
