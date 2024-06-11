# frozen-string-literal: true

module Swars
  module User::Stat
    class ProSkillExceedStat < Base
      delegate *[
        :ids_scope,
        :xmode_judge_stat,
        :xmode_stat,
      ], to: :@stat

      def to_win_lose_chart
        if judge_counts = to_win_lose_h
          { judge_counts: judge_counts }
        end
      end

      def to_win_lose_h
        win  = counts_hash[:win]
        lose = counts_hash[:lose]
        if win || lose
          {
            :win  => win || 0,
            :lose => lose || 0,
          }
        end
      end

      # 指導の平手で十段との勝ち負け数
      def counts_hash
        @counts_hash ||= yield_self do
          if xmode_stat.exist?(:"指導")
            s = ids_scope
            s = s.win_only
            s = s.joins(battle: [:xmode, :preset])
            # この条件を入れなければプロ側の成績もわかる
            if false
              s = s.joins(op_user: :grade)
              s = s.where(Grade.arel_table[:key].eq(:"十段"))
            end
            s = s.where(Xmode.arel_table[:key].eq(:"指導"))
            s = s.where(Preset.arel_table[:key].eq(:"平手"))
            s = s.joins(:judge).group(Judge.arel_table[:key])
            s = s.count.symbolize_keys
          else
            {}
          end
        end
      end
    end
  end
end
