require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      room_setup("my_room", "alice")                    # aliceが部屋を作る
    end
    b_block do
      room_setup("my_room", "bob")                      # bobも同じ部屋に入る
      hamburger_click
      os_modal_handle                                   # 「順番設定」モーダルを開く (まだ無効の状態)
    end
    a_block do
      hamburger_click
      os_modal_handle                                   # 「順番設定」モーダルを開く
      main_switch_toggle                                # 有効スイッチをクリック (最初なので同時に適用を押したの同じで内容も送信)
      action_assert(0, "alice", "順番 ON")              # aliceが有効にしたことが(ActionCable経由で)自分に伝わった
      modal_close_handle                                # 閉じる (ヘッダーに置いている)
    end
    b_block do
      action_assert(0, "alice", "順番 ON")
      assert_selector(".OrderSettingModalTable")        # 同期しているのでbob側のモーダルも有効になっている
      modal_close_handle                                # 閉じる (ヘッダーに置いている)
      assert_member_list(1, "is_turn_active", "alice")  # 1人目(alice)に丸がついている
      assert_member_list(2, "is_turn_standby", "bob")   # 2人目(bob)は待機中
      piece_move_x("77", "76", "☗7六歩")                # なので2番目のbobは指せない
    end
    a_block do
      assert_member_list(1, "is_turn_active", "alice")  # 1人目(alice)に丸がついている
      assert_member_list(2, "is_turn_standby", "bob")   # 2人目(bob)は待機中
      piece_move_o("77", "76", "☗7六歩")                # aliceが1番目なので指せる
      assert_text("次は、bobさんの手番です")
    end
    b_block do
      assert_system_variables(:tn_counter, 1)           # bobさんだけに牛が知らせている
    end
    a_block do
      piece_move_x("33", "34", "☖3四歩")                # aliceもう指したので指せない
      assert_member_list(1, "is_turn_standby", "alice") # 1人目(alice)に丸がついていない
      assert_member_list(2, "is_turn_active", "bob")    # 2人目(bob)は指せるので丸がついている
    end
    b_block do
      piece_move_o("33", "34", "☖3四歩")                # 2番目のbobは指せる
      assert_text("次は、aliceさんの手番です")
      assert_system_variables(:tn_counter, 1)           # aliceさんの手番なので出ない(変化せず)
    end
  end
end
