require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name)
    room_setup_by_user(user_name)
  end

  it "works" do
    window_a { case1(:a) }
    window_b { case1(:b) }
    window_a { piece_move_o("77", "76", "☗7六歩") }
    window_b { piece_move_o("33", "34", "☖3四歩") }
    window_a { piece_move_o("27", "26", "☗2六歩") }
    window_b { piece_move_o("83", "84", "☖8四歩") }
    window_a { sp_controller_click(:previous) }
    window_b { assert_turn(3) }
    window_a { sp_controller_click(:first) }
    window_b { assert_turn(0) }
    window_a { sp_controller_click(:next) }
    window_b { assert_turn(1) }
    window_a { sp_controller_click(:last) }
    window_b { assert_turn(4) }
  end
end
