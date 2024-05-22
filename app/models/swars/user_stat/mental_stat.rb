# frozen-string-literal: true

module Swars
  module UserStat
    class MentalStat < Base
      delegate *[
        :averages_hash,
      ], to: "@user_stat.tavg_stat"

      # 不屈の闘志
      def level
        if v = raw_level
          (v.fdiv(win + lose) * 100).round
        end
      end

      def raw_level
        if win && lose
          (lose - win).to_f
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
