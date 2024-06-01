# frozen-string-literal: true

module Swars
  module UserStat
    class ConsecutiveWinsAndLossesStat < Base
      delegate *[
        :ordered_ids_scope,
      ], to: :@user_stat

      # なければ nil を返す
      def to_chart(key)
        to_h[key]
      end

      # 連勝・連敗
      def count(key)
        to_h.fetch(key, 0)
      end

      def to_h
        @to_h ||= yield_self do
          g = ordered_ids_scope.s_pluck_judge_key.chunk(&:itself)
          g.each_with_object({}) do |(k, v), m|
            k = k.to_sym
            m[k] = [m[k] || 0, v.size].max
          end
        end
      end
    end
  end
end
