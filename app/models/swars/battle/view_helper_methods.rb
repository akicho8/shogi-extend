module Swars
  class Battle
    concern :ViewHelperMethods do
      def left_right_memberships(current_swars_user)
        a = memberships.to_a
        if current_swars_user
          if a.last.user == current_swars_user # 対象者がいるときは対象者を左
            a = a.reverse
          end
        else
          if win_user_id
            if a.last.judge_key == "win" # 対象者がいないときは勝った方を左
              a = a.reverse
            end
          end
        end
        a
      end
    end
  end
end
