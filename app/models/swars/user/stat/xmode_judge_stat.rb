# frozen-string-literal: true

module Swars
  module User::Stat
    class XmodeJudgeStat < Base
      delegate *[
        :ids_scope,
        :xmode_stat,
      ], to: :@stat

      def strong_in_friends?
        count_by(:"友達", :win) > count_by(:"友達", :lose)
      end

      def ratio_by_xmode_key(xmode_key)
        win = count_by(xmode_key, :win)
        lose = count_by(xmode_key, :lose)
        denominator = win + lose
        if denominator.positive?
          win.fdiv(denominator)
        else
          0.0
        end
      end

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
        assert_xmode_key(xmode_key)
        assert_judge_key(judge_key)
        counts_hash.has_key?([xmode_key, judge_key])
      end

      # Swars::User["SugarHuuko"].stat.xmode_judge_stat.count_by(:"野良", :win) # => 39
      def count_by(xmode_key, judge_key)
        assert_xmode_key(xmode_key)
        assert_judge_key(judge_key)
        counts_hash.fetch([xmode_key, judge_key], 0)
      end

      # 未使用
      # 分母に引き分けも含まれるため使いにくい
      # 本当に必要なのは win / (win + lose) である
      # Swars::User["SugarHuuko"].stat.xmode_judge_stat.ratio_by(:"野良", :win) # => 0.78
      def ratio_by(xmode_key, judge_key)
        denominator = xmode_stat.count(xmode_key)
        if denominator.positive?
          count = count_by(xmode_key, judge_key)
          count.fdiv(denominator)
        end
      end

      # => {[:"野良", :win]=>39, [:"野良", :lose]=>8, [:"野良", :draw]=>3}
      def counts_hash
        @counts_hash ||= yield_self do
          s = ids_scope
          s = s.joins(:battle => :xmode)
          s = s.joins(:judge)
          s = s.group(Xmode.arel_table[:key])
          s = s.group(Judge.arel_table[:key])
          s.count.transform_keys { |e| e.collect(&:to_sym) }
        end
      end
    end
  end
end
