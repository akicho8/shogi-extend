require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      room_setup("test_room", "alice", auto_room_url_copy_modal_p: true)
      assert_member_exist("alice")
      assert_text "部屋のリンクをコピーしますか？", wait: 30
    end
    b_block do
      room_setup("test_room", "bob", auto_room_url_copy_modal_p: true)
      assert_member_exist("bob")
      assert_no_text "部屋のリンクをコピーしますか？", wait: 30 # 2人なので表示しない
    end
  end
end
