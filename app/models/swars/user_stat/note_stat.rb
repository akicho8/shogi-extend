# frozen-string-literal: true

module Swars
  module UserStat
    class NoteStat < Base
      delegate *[
        :ids_scope,
        :ids_count,
      ], to: :@user_stat

      # ○○での勝ち負け数
      def to_chart(tag_name)
        if ids_count.positive?
          s = ids_scope
          if false
            s = s.joins(:battle)
            # s = s.where(Battle.arel_table[:turn_max].gteq(14))
            # s = s.where(Battle.arel_table[:outbreak_turn].not_eq(nil))
            # s = s.where(Battle.arel_table[:critical_turn].not_eq(nil)) # 1回でも駒の交換があったもの
            # s = s.where.not(Battle.arel_table[:win_user_id].eq(nil))
          end
          s = s.tagged_with(tag_name, on: :note_tags)
          counts = s.s_group_judge_key.count
          if counts.present?
            { judge_counts: counts }
          end
        end
      end
    end
  end
end
