require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a { room_setup_by_user(:a) }
    window_b { room_setup_by_user(:b) }
    window_b do
      os_modal_open                                   # 「順番設定」モーダルを開く (まだ無効の状態)
    end
    window_a do
      os_modal_open                                   # 「順番設定」モーダルを開く
      os_switch_toggle                                # 有効スイッチをクリック
      os_submit_button_click                          # 確定
      os_modal_close                                  # 閉じる (ヘッダーに置いている)
      assert_action(:a, "順番 ON")               # aが有効にしたことが(ActionCable経由で)自分に伝わった
      clock_start                                     # 時計も開始する(これは手番通知条件に時計が動いていることを含むため)
    end
    window_b do
      assert_selector(".TeamsContainer")              # 同期しているので b 側のモーダルも有効になっている
      os_modal_close                                  # 閉じる (ヘッダーに置いている)
      assert_member_status(:a, :is_battle_current_player)  # 1人目(a)に丸がついている
      assert_member_status(:b, :is_battle_other_player)   # 2人目(b)は待機中
      piece_move_x("77", "76", "☗7六歩")              # なので2番目の b は指せない
    end
    window_a do
      assert_member_status(:a, :is_battle_current_player)  # 1人目(a)に丸がついている
      assert_member_status(:b, :is_battle_other_player)   # 2人目(b)は待機中
      piece_move_o("77", "76", "☗7六歩")              # aが1番目なので指せる
      assert_var(:next_turn_message, "次は、#{:b}さんの手番です")
    end
    window_b do
      assert_var(:tn_bell_count, 1)                      #  b さんだけに牛が知らせている
    end
    window_a do
      piece_move_x("33", "34", "☖3四歩")              # aもう指したので指せない
      assert_member_status(:a, :is_battle_other_player) # 1人目(a)に丸がついていない
      assert_member_status(:b, :is_battle_current_player)    # 2人目(b)は指せるので丸がついている
    end
    window_b do
      piece_move_o("33", "34", "☖3四歩")              # 2番目の b は指せる
      assert_var(:next_turn_message, "次は、#{:a}さんの手番です")
      assert_var(:tn_bell_count, 1)                      # a の手番なので出ない(変化せず)
    end
  end
end
