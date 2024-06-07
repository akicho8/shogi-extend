# frozen-string-literal: true

module Swars
  module User::Stat
    class XmodeJudgeStat < Base
      delegate *[
        :ids_scope,
        :total_judge_counts,
        :xmode_stat,
      ], to: :@stat

      # 友達対局での勝敗
      def to_chart(xmode_key)
        judge_keys = [:win, :lose]
        if judge_keys.any? { |e| exist?(xmode_key, e) }
          judge_counts = judge_keys.each_with_object({}) do |judge_key, m|
            m[judge_key] = count_by(xmode_key, judge_key)
          end
          { judge_counts: judge_counts }
        end
      end

      # Swars::User["SugarHuuko"].stat.xmode_judge_stat.exist?(:"野良", :win)
      def exist?(xmode_key, judge_key)
        key = [xmode_key.to_s, judge_key.to_s]
        counts_hash.has_key?(key)
      end

      # Swars::User["SugarHuuko"].stat.xmode_judge_stat.count_by(:"野良", :win) # => 39
      def count_by(xmode_key, judge_key)
        key = [xmode_key.to_s, judge_key.to_s]
        counts_hash.fetch(key, 0)
      end

      # Swars::User["SugarHuuko"].stat.xmode_judge_stat.ratio_by(:"野良", :win) # => 0.78
      def ratio_by(xmode_key, judge_key)
        denominator = xmode_stat.count(xmode_key)
        if denominator.positive?
          count = count_by(xmode_key, judge_key)
          count.fdiv(denominator)
        end
      end

      # => {["野良", "win"]=>39, ["野良", "lose"]=>8, ["野良", "draw"]=>3}
      def counts_hash
        @counts_hash ||= yield_self do
          s = ids_scope
          s = s.joins(:battle => :xmode)
          s = s.joins(:judge)
          s = s.group(Xmode.arel_table[:key])
          s = s.group(Judge.arel_table[:key])
          s.count
        end
      end
    end
  end
end
