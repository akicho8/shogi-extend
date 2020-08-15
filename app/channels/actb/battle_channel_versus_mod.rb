module Actb
  concern :BattleChannelVersusMod do
    included do
    end

    class_methods do
    end

    # 盤面を共有する
    def vs_func_play_board_share(data)
      data = data.to_options
      broadcast(:vs_func_play_board_share_broadcasted, data)
    end

    # 投了
    def vs_func_toryo_handle(data)
      data = data.to_options
      membership = current_battle.memberships.find(data[:membership_id])
      judge_final_set(membership.user, :lose, :f_success)
      broadcast(:vs_func_toryo_handle_broadcasted, data)
    end
  end
end
