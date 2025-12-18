require "#{__dir__}/sb_support_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a { visit_room(user_name: :a) }
    window_b { visit_room(user_name: :b)   }
    window_a do
      kifu_read_run
      assert_turn(1)
      assert_action_index(0, :a, "局面転送 #1")
      assert_action_index(1, :a, "棋譜読込後")
      assert_text "棋譜を読み込んで共有しました", wait: 5
    end
    window_b do
      assert_turn(1)
    end
  end
end
