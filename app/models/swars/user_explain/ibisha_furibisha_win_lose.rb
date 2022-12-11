module Swars
  module UserExplain
    class IbishaFuribishaWinLose
      def initialize(user_explain)
        @user_explain = user_explain
      end

      def ibisha_win_lose_params
        aggregate_for("居飛車")
      end

      def furibisha_win_lose_params
        aggregate_for("振り飛車")
      end

      private

      def aggregate_for(tag_name)
        win = on_note_tags_count(@user_explain.win_scope, tag_name)
        lose = on_note_tags_count(@user_explain.lose_scope, tag_name)
        if (win + lose).nonzero?
          { judge_counts: { win: win, lose: lose } }
        end
      end

      def on_note_tags_count(scope, tag_name)
        s = scope
        s = s.joins(:battle => :final)
        s = s.where(Final.arel_table[:key].eq_any(["TORYO", "TIMEOUT", "CHECKMATE", "DISCONNECT"]))
        s = s.where(Battle.arel_table[:turn_max].gteq(14))
        s = s.tagged_with(tag_name, on: :note_tags)
        s.count
      end
    end
  end
end
