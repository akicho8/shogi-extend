# frozen-string-literal: true

module Swars
  module User::Stat
    class JudgeFinalStat < Base
      delegate *[
        :ids_scope,
        :total_judge_stat,
      ], to: :stat

      # 特定の負け方を究めた率
      def master_ratio(final_key)
        if count = count_by(:lose, final_key)
          if count >= Config.master_count_gteq
            ratio_by(:lose, final_key)
          end
        end
      end

      # Swars::User["SugarHuuko"].stat.judge_final_stat.count_by(:win, :TORYO) # => 27
      def count_by(judge_key, final_key)
        assert_judge_key(judge_key)
        assert_final_key(final_key)
        counts_hash[[judge_key, final_key]]
      end

      # 例: ratio_by(:lose, :TORYO) だと「TORYO 回数 / lose 回数」となる (引き分けは考慮する必要がない)
      # Swars::User["SugarHuuko"].stat.judge_final_stat.ratio_by(:win, :TORYO) # => 0.6923076923076923
      def ratio_by(judge_key, final_key)
        if count = count_by(judge_key, final_key)
          if denominator = total_judge_stat.counts_hash[judge_key]
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
          s = s.where(Battle.arel_table[:turn_max].gteq(Config.establish_gteq))
          s = s.group(Judge.arel_table[:key], Final.arel_table[:key])
          s.count.transform_keys { |key| key.collect(&:to_sym) }
        end
      end
    end
  end
end
