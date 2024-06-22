# frozen-string-literal: true

module Swars
  module User::Stat
    class AverageMovesByOutcomeStat < Base
      delegate *[
        :ids_scope,
      ], to: :stat

      # 勝敗別平均手数
      def to_chart
        @to_chart ||= yield_self do
          keys = [:win, :lose]
          if keys.any? { |e| averages_hash.has_key?(e) }
            keys.collect do |key|
              info = JudgeInfo.fetch(key)
              value = averages_hash.fetch(info.key, 0).round
              { name: info.name, value: value }
            end
          end
        end
      end

      # {:win => 0.971469e2, :lose => 0.1110962e3, :draw => 0.29e2}
      def averages_hash
        @averages_hash ||= yield_self do
          s = ids_scope
          s = s.joins(:battle)
          s = s.s_group_judge_key
          if s = s.average(:turn_max)
            s.symbolize_keys
          end
        end
      end
    end
  end
end
