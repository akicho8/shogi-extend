require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a { room_setup_by_user("a") }
    window_b { room_setup_by_user("b") }
    window_a do
      order_set_on              # 順番設定ON
      assert_var("仮順序", "ab")
      assert_var("本順序", "ab")
    end
  end
end
