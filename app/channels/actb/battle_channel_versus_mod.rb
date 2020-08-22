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
    # rails r "p Actb::Battle.first.cache_key"
    # rails r "tp Actb::Battle.last"
    # rails r "tp Actb::VsRecord.last"
    def vs_func_toryo_handle(data)
      if once_run("vs_func_toryo_handle/#{current_battle.cache_key}")
        data = data.to_options
        current_battle.create_vs_record!(sfen_body: data[:vs_share_sfen])
        membership = current_battle.memberships.find(data[:membership_id])
        judge_final_set(membership.user, :lose, :f_success)
        broadcast(:vs_func_toryo_handle_broadcasted, data)
      end
    end
  end
end
