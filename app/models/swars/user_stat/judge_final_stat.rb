# frozen-string-literal: true

module Swars
  module UserStat
    class JudgeFinalStat < Base
      delegate *[
        :ids_scope,
        :total_judge_counts,
      ], to: :@user_stat

      # Swars::User["SugarHuuko"].user_stat.judge_final_stat.count_by(:win, :TORYO) # => 27
      def count_by(judge_key, final_key)
        key = [
          Judge.fetch(judge_key).key.to_s,
          Final.fetch(final_key).key.to_s,
        ]
        counts_hash[key]
      end

      # Swars::User["SugarHuuko"].user_stat.judge_final_stat.ratio_by(:win, :TORYO) # => 0.6923076923076923
      def ratio_by(judge_key, final_key)
        if count = count_by(judge_key, final_key)
          if denominator = total_judge_counts[judge_key.to_s]
            count.fdiv(denominator)
          end
        end
      end

      # 勝ち負けグループでの結末
      def to_chart(judge_key)
        list = []
        FinalInfo.each do |e|
          count = count_by(judge_key, e.key)
          if e.chart_required
            count ||= 0
          end
          if count
            list << {
              :key   => e.key,
              :name  => e.name,
              :value => count,
            }
          end
        end
        list
      end

      # {["win", "TORYO"]=>27, ["lose", "TORYO"]=>7, ["win", "CHECKMATE"]=>7, ["win", "TIMEOUT"]=>4, ["lose", "TIMEOUT"]=>1, ["draw", "DRAW_SENNICHI"]=>2}
      def counts_hash
        @counts_hash ||= yield_self do
          s = ids_scope
          s = s.joins(:battle => :final)
          s = s.joins(:judge)
          s = s.group(Judge.arel_table[:key], Final.arel_table[:key])
          s.count
        end
      end
    end
  end
end
