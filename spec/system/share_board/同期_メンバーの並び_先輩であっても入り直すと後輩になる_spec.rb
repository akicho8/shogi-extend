require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a do
      room_setup_by_user(:a)         # a先輩が部屋を作る
      assert_member_index(:a, 1)     # 一番上にaがいる
    end
    window_b do
      room_setup_by_user(:b)           # b後輩が同じ入退室
      assert_member_index(:b, 2)       # 最後に追加される
    end
    window_a do
      piece_move_o("77", "76", "☗7六歩") # aが1手指す
    end
    window_b do
      assert_text("☗7六歩")              # b 側にも伝わっている
      sp_controller_click("first")       # 再起動時にbから受けとったか確認しやすいように0手目にしておく
      assert_turn(0)
    end
    window_a do
      gate_leave_handle                  # 軽く退室
      room_setup_by_fillin_params        # 再度入室(部屋と名前はすでに入力済みになっている)
      assert_turn(0)                     # bから0手目をもらった
      assert_member_index(:b, 1)       # 並びは後輩だったbが先輩に
      assert_member_index(:a, 2)     # 先輩だったaは後輩になっている
    end
  end
end
