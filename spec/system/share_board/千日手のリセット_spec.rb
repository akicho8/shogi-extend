require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "スライダーで2手目から1手目に戻しただけで千日手情報をリセットする" do
    visit_app
    king_move_up_down
    assert_var("perpetual_cop.count", 4)
    sp_controller_click("previous")
    assert_var("perpetual_cop.count", 0)
  end

  it "入室時にリセットする" do
    window_a do
      visit_app
      king_move_up_down
      assert_var("perpetual_cop.count", 4)
      room_menu_open_and_input(:test_room, :a) # 入室
      assert_var("perpetual_cop.count", 0)
    end
  end

  it "退室時にリセットする" do
    window_a do
      room_setup_by_user(:a)
      king_move_up_down
      assert_var("perpetual_cop.count", 4)
      gate_leave_handle
      assert_var("perpetual_cop.count", 0)
    end
  end

  it "同期したとき相手もリセットする" do
    window_a { room_setup_by_user(:a) }
    window_b { room_setup_by_user(:b) }
    window_a do
      room_setup_by_user(:a)
      king_move_up_down
      assert_var("perpetual_cop.count", 4)
      gate_leave_handle
      assert_var("perpetual_cop.count", 0)
    end
  end
end
