# frozen-string-literal: true

module Swars
  module User::Stat
    class FairPlayStat < Base
      delegate *[
        :ids_count,
      ], to: :@stat

      def percentage_score
        @percentage_score ||= yield_self do
          if score
            (score.fdiv(score_max) * 100.0).floor
          end
        end
      end

      def score
        @score ||= yield_self do
          if ids_count.positive?
            FairPlayInfo.sum do |e|
              @stat.instance_eval(&e.if_cond) ? e.score : 0
            end
          end
        end
      end

      def to_a
        FairPlayInfo.collect do |e|
          {
            "スコア" => e.score,
            "項目"   => e.key,
            "結果"   => @stat.instance_eval(&e.if_cond) ? e.score : "",
          }
        end
      end

      private

      def score_max
        @score_max ||= FairPlayInfo.sum(&:score)
      end
    end
  end
end
