# frozen-string-literal: true

module Swars
  module User::Stat
    class GuidelineStat < Base
      class << self
        def report(options = {})
          options = {
            sample_max: 200,
          }.merge(options)
          Rails.application.credentials[:expert_import_user_keys].collect { |key|
            if user = Swars::User[key]
              guideline_stat = user.stat(options).guideline_stat
              {
                :key              => key,
                :score            => guideline_stat.score,
                :percentage_score => guideline_stat.percentage_score_float,
              }
            end
          }.compact.sort_by { |e| -e[:score].to_i }
        end
      end

      delegate *[
        :ids_count,
      ], to: :@stat

      def percentage_score
        @percentage_score ||= yield_self do
          if v = percentage_score_float
            v.floor
          end
        end
      end

      def percentage_score_float
        @percentage_score ||= yield_self do
          if score
            (score.fdiv(total_weight) * 100.0)
          end
        end
      end

      def score
        @score ||= yield_self do
          if ids_count.positive?
            GuidelineInfo.sum do |e|
              @stat.instance_eval(&e.if_cond) ? e.weight : 0
            end
          end
        end
      end

      # 確認用
      def to_a
        GuidelineInfo.collect do |e|
          {
            "重み"          => e.weight,
            "重み/トータル" => e.weight.fdiv(total_weight).round(2),
            "項目"          => e.key,
            "結果"          => @stat.instance_eval(&e.if_cond) ? e.weight : "",
          }
        end
      end

      def total_weight
        @total_weight ||= GuidelineInfo.sum(&:weight)
      end
    end
  end
end
