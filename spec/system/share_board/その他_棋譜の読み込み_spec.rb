require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block { visit_app(room_key: :test_room, user_name: "alice") }
    b_block { visit_app(room_key: :test_room, user_name: "bob")   }
    a_block do
      kifu_yomikomi
      assert_turn(1)
      assert_action_index(0, "alice", "局面転送 #1")
      assert_action_index(1, "alice", "棋譜読込後")
      assert_text "棋譜を読み込んで共有しました", wait: 5
    end
    b_block do
      assert_turn(1)
    end
  end
end
