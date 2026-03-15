require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a { room_setup_by_user(:a) }
    window_b { room_setup_by_user(:b) }

    # a が1手指して印をつける。それは b にも反映されている。
    window_a do
      piece_move_o("77", "76", "☗7六歩") # a が指す
      board_place("76").right_click       # 印をつける
    end

    window_a { assert_mark_exist }            # a 側ではもちろん印はついている
    window_b { assert_mark_exist }            # b 側でも印はついている

    window_a { sp_controller_click("first") } # a が 0 手目に戻す (debounce の leading が発動するためすぐにブロードキャストする)
    window_a { assert_mark_none }             # a 側ではすぐに印は消えている
    window_b { assert_mark_none }             # b 側でも即反映で消えている
  end
end
