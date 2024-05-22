# frozen-string-literal: true

module Swars
  module UserStat
    class TavgStat < Base
      delegate *[
        :ids_scope,
      ], to: :@user_stat

      # 勝敗別平均手数
      def to_chart
        @to_chart ||= yield_self do
          keys = [:win, :lose]
          if keys.any? { |e| averages_hash.has_key?(e) }
            keys.collect do |key|
              info = JudgeInfo.fetch(key)
              value = (averages_hash[info.key] || 0).round
              { name: info.name, value: value }
            end
          end
        end
      end

      # こんなよくわからない二択のメッセージを出すより単刀直入に「不屈の闘志」を整数値で出す方がよい
      def bottom_message
        if averages_hash
          win  = averages_hash[:win]
          lose = averages_hash[:lose]
          if win && lose
            case
            when lose < win
              "負けそうなときは諦めがちなタイプ"
            when lose > win
              "負けそうなときも粘り強く指すタイプ"
            end
          end
        end
      end

      # {:win => 0.971469e2, :lose => 0.1110962e3, :draw => 0.29e2}
      def averages_hash
        @averages_hash ||= yield_self do
          s = ids_scope
          s = s.s_group_judge_key
          if s = s.joins(:battle).average(:turn_max)
            s.symbolize_keys
          end
        end
      end
    end
  end
end
