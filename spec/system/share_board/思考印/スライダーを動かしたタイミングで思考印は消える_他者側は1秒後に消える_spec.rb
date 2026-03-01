require "#{__dir__}/helper"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a { room_setup_by_user(:a) }
    window_b { room_setup_by_user(:b) }

    # a が1手指して印をつける。それは b にも反映されている。
    window_a do
      piece_move_o("77", "76", "☗7六歩") # a が指す
      board_place("76").right_click      # 印をつける
      assert_mark_exist                  # 印はついている
    end
    window_b { assert_mark_exist }       # b 側でも印はついている

    window_a do
      sp_controller_click("first")       # a が 0 手目に戻す
      assert_mark_none                   # a 側ではすぐに印は消えている (b に反映されるのは1秒後)
    end
    window_b do
      assert_mark_exist                  # b にはまだ反映されていないが
      assert_turn(0)                     # 1秒待つと
      assert_mark_none                   # 反映されて (消されて) いる
    end
  end
end
