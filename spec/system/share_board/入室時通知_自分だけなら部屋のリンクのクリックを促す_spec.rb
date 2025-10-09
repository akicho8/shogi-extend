require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    window_a do
      room_setup_by_user(:alice)
      assert_member_exist(:alice)
      assert_text "部屋のリンクを仲間に伝えよう", wait: 10
    end
    window_b do
      room_setup_by_user(:bob)
      assert_member_exist(:bob)
      assert_no_text "部屋のリンクを仲間に伝えよう", wait: 10 # 2人なので表示しない
    end
  end
end
