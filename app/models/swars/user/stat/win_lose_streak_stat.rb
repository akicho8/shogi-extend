# frozen-string-literal: true

module Swars
  module User::Stat
    class WinLoseStreakStat < Base
      delegate *[
        :ordered_ids_scope,
      ], to: :stat

      def five_win?
        max(:win) >= 5
      end

      def ten_win?
        max(:win) >= 10
      end

      def waves_strong?
        max(:win) >= 8 && max(:lose) >= 8
      end

      # 連勝・連敗
      def max(key)
        to_h.fetch(key, 0)
      end

      def to_h
        @to_h ||= yield_self do
          g = ordered_ids_scope.s_pluck_judge_key.chunk(&:itself)
          g.each_with_object({}) do |(judge_key, list), hv|
            judge_key = judge_key.to_sym
            hv[judge_key] = [hv.fetch(judge_key, 0), list.size].max
          end
        end
      end
    end
  end
end
