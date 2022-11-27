require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      room_setup("test_room", "alice")
      assert_member_exist("alice")
      assert_text "部屋のリンクを仲間に伝えよう", wait: 30
    end
    b_block do
      room_setup("test_room", "bob")
      assert_member_exist("bob")
      assert_no_text "部屋のリンクを仲間に伝えよう", wait: 30 # 2人なので表示しない
    end
  end
end
