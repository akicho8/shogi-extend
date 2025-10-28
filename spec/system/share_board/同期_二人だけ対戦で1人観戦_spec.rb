require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a { room_setup_by_user(:a) }         # a が部屋を作る
    window_b { room_setup_by_user(:b)   }         # b も同じ部屋に入る
    window_c { room_setup_by_user(:c) }         # carolは観戦目的で入る
    window_a do
      os_modal_open                                 # 「順番設定」モーダルを開く
      os_switch_toggle                              # 有効スイッチをクリック
      drag_to_watch("is_team_black", 1)                 # 黒の[1]にいる c を観戦に移動する
      os_submit_button_click                        # 適用クリック
      os_modal_close                                # 閉じる (ヘッダーに置いている)
      clock_start                                   # 時計を開始する
    end
    window_c do
      assert_member_status(:a, :is_battle_current_player) # 1人目(a)に丸がついている
      assert_member_status(:b, :is_battle_other_player)  # 2人目(b)は待機中
      assert_member_status(:c, :is_battle_watcher)    # 3人目(c)は観戦中
      piece_move_x("77", "76", "☗7六歩")           #  なので3番目のcarolは指せない
    end
    window_a do
      piece_move_o("77", "76", "☗7六歩")            # 1番目のaが指す
    end
    window_b do
      piece_move_o("33", "34", "☖3四歩")            # 2番目のbが指す
    end
    window_c do
      piece_move_x("27", "26", "☗2六歩")            # 3番目のcarolは観戦者なので指せない
    end
    window_a do
      piece_move_o("27", "26", "☗2六歩")            # 1順してaが3手目を指す
    end
  end
end
