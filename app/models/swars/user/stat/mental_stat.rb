# frozen-string-literal: true

module Swars
  module User::Stat
    class MentalStat < Base
      class << self
        def report
          Swars::User::Vip.auto_crawl_user_keys.collect { |key|
            if user = Swars::User[key]
              mental_stat = user.stat(sample_max: 200).mental_stat
              {
                :key        => key,
                :level      => mental_stat.level,
                :raw_level  => mental_stat.raw_level,
                :hard_brain => mental_stat.hard_brain?,
              }
            end
          }.compact.sort_by { |e| -e[:level] }
        end
      end

      delegate *[
        :averages_hash,
      ], to: "@stat.average_moves_by_outcome_stat"

      # 不屈の闘志
      def level
        if v = raw_level
          (v.fdiv(win + lose) * 100).round
        end
      end

      # 心強すぎマン
      def hard_brain?
        (level || 0) >= 5
      end

      def raw_level
        if win && lose
          (lose - win).to_f
        end
      end

      def guideline?
        if win && lose
          lose > win
        else
          true
        end
      end

      def win
        averages_hash[:win]
      end

      def lose
        averages_hash[:lose]
      end
    end
  end
end
