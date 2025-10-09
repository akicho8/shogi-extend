require "#{__dir__}/shared_methods"

RSpec.describe "順番設定_補助機能_手番通知", type: :system, share_board_spec: true do
  def case1(user_name)
    room_setup2(user_name, :room_restore_key => :skip)
  end

  it "works" do
    window_a do
      case1(:alice)                                  # aliceが部屋を作る
    end
    window_b do
      case1(:bob)                                    # bobも同じ入退室
      os_modal_open                                   # 「順番設定」モーダルを開く (まだ無効の状態)
    end
    window_a do
      os_modal_open                                   # 「順番設定」モーダルを開く
      os_switch_toggle                                # 有効スイッチをクリック
      os_submit_button_click                          # 確定
      os_modal_close                                  # 閉じる (ヘッダーに置いている)
      assert_action(:alice, "順番 ON")               # aliceが有効にしたことが(ActionCable経由で)自分に伝わった
      clock_start                                     # 時計も開始する(これは手番通知条件に時計が動いていることを含むため)
    end
    window_b do
      assert_selector(".TeamsContainer")              # 同期しているのでbob側のモーダルも有効になっている
      os_modal_close                                  # 閉じる (ヘッダーに置いている)
      assert_member_status(:alice, :is_turn_active)  # 1人目(alice)に丸がついている
      assert_member_status(:bob, :is_turn_standby)   # 2人目(bob)は待機中
      piece_move_x("77", "76", "☗7六歩")              # なので2番目のbobは指せない
    end
    window_a do
      assert_member_status(:alice, :is_turn_active)  # 1人目(alice)に丸がついている
      assert_member_status(:bob, :is_turn_standby)   # 2人目(bob)は待機中
      piece_move_o("77", "76", "☗7六歩")              # aliceが1番目なので指せる
      assert_var(:next_turn_message, "次は、bobさんの手番です")
    end
    window_b do
      assert_var(:tn_counter, 1)                      # bobさんだけに牛が知らせている
    end
    window_a do
      piece_move_x("33", "34", "☖3四歩")              # aliceもう指したので指せない
      assert_member_status(:alice, :is_turn_standby) # 1人目(alice)に丸がついていない
      assert_member_status(:bob, :is_turn_active)    # 2人目(bob)は指せるので丸がついている
    end
    window_b do
      piece_move_o("33", "34", "☖3四歩")              # 2番目のbobは指せる
      assert_var(:next_turn_message, "次は、aliceさんの手番です")
      assert_var(:tn_counter, 1)                      # aliceさんの手番なので出ない(変化せず)
    end
  end
end
