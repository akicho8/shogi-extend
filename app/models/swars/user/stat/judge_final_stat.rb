# frozen-string-literal: true

module Swars
  module User::Stat
    class JudgeFinalStat < Base
      delegate *[
        :ids_scope,
        :total_judge_counts,
      ], to: :@stat

      # 投了を究めた
      def toryo_master?
        (ratio_by(:lose, :TORYO) || 0) >= 1.0
      end

      # Swars::User["SugarHuuko"].stat.judge_final_stat.count_by(:win, :TORYO) # => 27
      def count_by(judge_key, final_key)
        assert_judge_key(judge_key)
        assert_final_key(final_key)
        counts_hash[[judge_key, final_key]]
      end

      # Swars::User["SugarHuuko"].stat.judge_final_stat.ratio_by(:win, :TORYO) # => 0.6923076923076923
      def ratio_by(judge_key, final_key)
        if count = count_by(judge_key, final_key)
          if denominator = total_judge_counts[judge_key]
            count.fdiv(denominator)
          end
        end
      end

      # 勝ち負けグループでの結末
      def to_chart(judge_key)
        counts = FinalInfo.collect { |e| count_by(judge_key, e.key) }
        if counts.any?
          list = []
          FinalInfo.each.with_index do |e, i|
            count = counts[i]
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
      end

      def counts_hash
        @counts_hash ||= yield_self do
          s = ids_scope
          s = s.joins(:battle => :final)
          s = s.joins(:judge)
          s = s.where(Battle.arel_table[:turn_max].gteq(2)) # 2手指せば通信環境は正常である(通信不良なら1手目で終わる)
          s = s.group(Judge.arel_table[:key], Final.arel_table[:key])
          s.count.transform_keys { |key| key.collect(&:to_sym) }
        end
      end
    end
  end
end
