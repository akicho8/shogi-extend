# frozen-string-literal: true

module Swars
  module User::Stat
    class XmodeJudgeStat < Base
      MINIMUM_NUMBER_OF_BATTLES = 8 # 最低必要対局数

      delegate *[
        :ids_scope,
        :xmode_stat,
      ], to: :stat

      ################################################################################

      # 友達対局で勝ち越した？
      def friend_battle_katikosi?
        if win_lose_total(:"友達") >= MINIMUM_NUMBER_OF_BATTLES
          ratio_by_xmode_key(:"友達") > 0.5
        end
      end

      # 友達対局で切磋琢磨した
      def friend_battle_sessatakuma?
        if win_lose_total(:"友達") >= MINIMUM_NUMBER_OF_BATTLES
          (0.3...0.7).cover?(ratio_by_xmode_key(:"友達"))
        end
      end

      # 友達対局で無双した度合い
      def friend_kill_ratio
        if win_lose_total(:"友達") >= MINIMUM_NUMBER_OF_BATTLES
          if v = ratio_by_xmode_key(:"友達")
            ab = 0.75..1.00
            if v >= ab.min
              map_range(v, *ab.minmax, 0.0, 1.0)
            end
          end
        end
      end

      # # 友達対局で無双した度合い
      # def friend_kill_ratio
      #   xmode_key = :"友達"
      #   if win_lose_total(xmode_key) >= MINIMUM_NUMBER_OF_BATTLES
      #     if ratio_by_xmode_key(xmode_key) >= 0.75
      #       count_by(xmode_key, :win) - count_by(xmode_key, :lose)
      #     end
      #   end
      # end

      ################################################################################

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

      def win_lose_total(xmode_key)
        count_by(xmode_key, :win) + count_by(xmode_key, :lose)
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
