require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    @RESEND_DELAY = 3
    window_a do
      visit_room(user_name: :a, FIXED_ORDER: :a, RESEND_DELAY: @RESEND_DELAY)
      gate_leave_handle
      piece_move("77", "76")
      sleep(@RESEND_DELAY)
      assert_no_text("同期失敗")
    end
  end
end
