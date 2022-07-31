require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    @RETRY_DELAY = 3
    a_block do
      visit_app(room_code: :my_room, force_user_name: "alice", ordered_member_names: "alice", RETRY_DELAY: @RETRY_DELAY)
      room_leave
      piece_move("77", "76")
      sleep(@RETRY_DELAY)
      assert_no_text("同期失敗")
    end
  end
end
