module Swars
  module UserInfo
    class NoteJudgeInfo
      def initialize(user_info, tag_name)
        @user_info = user_info
        @tag_name = tag_name
      end

      def to_chart
        win = on_note_tags_count(@user_info.win_scope)
        lose = on_note_tags_count(@user_info.lose_scope)
        if (win + lose).nonzero?
          { judge_counts: { win: win, lose: lose } }
        end
      end

      private

      def on_note_tags_count(scope)
        s = scope
        s = s.joins(:battle => :final)
        s = s.where(Final.arel_table[:key].eq_any(["TORYO", "TIMEOUT", "CHECKMATE", "DISCONNECT"]))
        s = s.where(Battle.arel_table[:turn_max].gteq(14))
        s = s.tagged_with(@tag_name, on: :note_tags)
        s.count
      end
    end
  end
end
