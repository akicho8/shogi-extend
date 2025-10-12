require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    window_a { room_setup_by_user(:alice) }         # alice が部屋を作る
    window_b { room_setup_by_user(:bob)   }         # bob も同じ部屋に入る
    window_c { room_setup_by_user(:carol) }         # carolは観戦目的で入る
    window_a do
      os_modal_open                                 # 「順番設定」モーダルを開く
      os_switch_toggle                              # 有効スイッチをクリック
      drag_to_watch("dnd_black", 1)                 # 黒の[1]にいる carol を観戦に移動する
      os_submit_button_click                        # 適用クリック
      os_modal_close                                # 閉じる (ヘッダーに置いている)
    end
    window_c do
      assert_member_status(:alice, :is_turn_active) # 1人目(alice)に丸がついている
      assert_member_status(:bob, :is_turn_standby)  # 2人目(bob)は待機中
      assert_member_status(:carol, :is_watching)    # 3人目(carol)は観戦中
      piece_move_x("77", "76", "☗7六歩")            #  なので3番目のcarolは指せない
    end
    window_a do
      piece_move_o("77", "76", "☗7六歩")            # 1番目のaliceが指す
    end
    window_b do
      piece_move_o("33", "34", "☖3四歩")            # 2番目のbobが指す
    end
    window_c do
      piece_move_x("27", "26", "☗2六歩")            # 3番目のcarolは観戦者なので指せない
    end
    window_a do
      piece_move_o("27", "26", "☗2六歩")            # 1順してaliceが3手目を指す
    end
  end
end
