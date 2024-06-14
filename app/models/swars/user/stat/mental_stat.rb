# frozen-string-literal: true

module Swars
  module User::Stat
    class MentalStat < Base
      class << self
        def report(options = {})
          Swars::User::Vip.auto_crawl_user_keys.collect { |user_key|
            if user = Swars::User[user_key]
              mental_stat = user.stat(options).mental_stat
              {
                :user_key   => user.key,
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
        level.try { |e| e >= 5 }
      end

      def raw_level
        if win && lose
          (lose - win).to_f
        end
      end

      # 心が弱いレベル
      def heart_weak_level
        if win && lose
          if lose < win
            win - lose
          end
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
