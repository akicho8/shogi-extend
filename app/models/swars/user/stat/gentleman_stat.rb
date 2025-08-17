# frozen-string-literal: true

module Swars
  module User::Stat
    class GentlemanStat < Base
      SCORE_DEFAULT   = 100.0

      class << self
        def report(options = {})
          options = {
            :user_keys => User::Vip.auto_crawl_user_keys,
          }.merge(options)

          options[:user_keys].collect { |user_key|
            if user = User[user_key]
              stat = user.stat(options)
              gentleman_stat = stat.gentleman_stat
              {
                "ウォーズID" => user.key,
                "件数"       => stat.ids_count,
                "点"         => gentleman_stat.final_score.try { floor },
                **gentleman_stat.to_h,
              }
            end
          }.compact.sort_by { |e| -e["点"].to_i }
        end
      end

      delegate *[
        :ids_count,
      ], to: :stat

      def badge_score
        if final_score
          if ids_count >= Config.master_count_gteq
            final_score
          end
        end
      end

      def final_score
        @final_score ||= yield_self do
          if ids_count.positive?
            v = SCORE_DEFAULT - final_penalty
            if false
              v = [v, 0].max
            end
            v
          end
        end
      end

      def final_penalty
        @final_penalty ||= yield_self do
          Rails.logger.tagged("final_penalty") do
            PenaltyInfo.sum do |e|
              e.weight * (@stat.instance_exec(&e.x_count) || 0)
            end
          end
        end
      end

      def to_a
        PenaltyInfo.collect do |e|
          x_count = @stat.instance_exec(&e.x_count).to_f
          {
            "項目" => e.short_name,
            "重み" => e.weight,
            "回数" => x_count.try { zero? ? "" : self },
            "減点" => penalty_count_inspect(e),
          }
        end
      end

      def to_h
        PenaltyInfo.each_with_object({}) do |e, m|
          m[e.short_name] = penalty_count_inspect(e)
        end
      end

      private

      def penalty_count_inspect(e)
        x_count = @stat.instance_exec(&e.x_count).to_f
        if x_count.nonzero?
          (e.weight * x_count).round(2)
        end
      end
    end
  end
end
