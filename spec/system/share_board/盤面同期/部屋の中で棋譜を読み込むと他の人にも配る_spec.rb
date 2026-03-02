require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a { visit_room(user_name: :a) }
    window_b { visit_room(user_name: :b) }
    window_a { kifu_read_run }
    window_a { assert_turn(1) }
    window_b { assert_turn(1) }
    window_b do
      assert_history_index_behavior(0, :a, "棋譜読込")
      assert_text "aさんが棋譜を読み込みました"
    end
  end
end
