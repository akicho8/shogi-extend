module Swars
  class UserInfo
    class IbishaFuribishaWinLose
      def initialize(user_info)
        @user_info = user_info
      end

      def ibisya_win_lose_params
        win, lose = ibisya_win_lose
        if (win + lose).nonzero?
          {
            judge_counts: { win: win, lose: lose },
          }
        end
      end

      def furibisha_win_lose_params
        win, lose = furibisha_win_lose
        if (win + lose).nonzero?
          {
            judge_counts: { win: win, lose: lose },
          }
        end
      end

      private

      def ibisya_win_lose
        [
          on_note_tags_count(@user_info.win_scope, "居飛車"),
          on_note_tags_count(@user_info.lose_scope, "居飛車"),
        ]
      end

      def furibisha_win_lose
        [
          on_note_tags_count(@user_info.win_scope, "振り飛車"),
          on_note_tags_count(@user_info.lose_scope, "振り飛車"),
        ]
      end

      def on_note_tags_count(scope, tag_name)
        if @user_info.real_count.zero?
          return 0
        end
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
