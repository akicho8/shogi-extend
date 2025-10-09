require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    window_a do
      room_setup2(:alice, :room_restore_key => :skip)     # alice先輩が部屋を作る
      assert_member_index(:alice, 1)    # 一番上にaliceがいる
      sleep(2)                           # 先輩後輩は最低1秒毎の差なので2秒待てば確実にbobは後輩になる
    end
    window_b do
      room_setup2(:bob, :room_restore_key => :skip)       # bob後輩が同じ入退室
      assert_member_index(:bob, 2)      # 最後に追加される
      sleep(2)                           # これでbobをレベル2ぐらいにはなる(aliceはレベル4)
    end
    window_a do
      piece_move_o("77", "76", "☗7六歩") # aliceが1手指す
    end
    window_b do
      assert_text("☗7六歩")              # bob 側にも伝わっている
      sp_controller_click("first")        # 再起動時にbobから受けとったか確認しやすいように0手目にしておく
      assert_turn(0)
    end
    window_a do
      room_leave_share                         # 軽く退室
      room_setup_by_fillin_params        # 再度入室(部屋と名前はすでに入力済みになっている)
      assert_turn(0)                     # bobから0手目をもらった
      assert_member_index(:bob, 1)      # 並びは後輩だったbobが先輩に
      assert_member_index(:alice, 2)    # 先輩だったaliceは後輩になっている
    end
  end
end
