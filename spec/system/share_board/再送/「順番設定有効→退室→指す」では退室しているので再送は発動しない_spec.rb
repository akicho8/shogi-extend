require "#{__dir__}/../shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    @RS_RESEND_DELAY = 3
    window_a do
      visit_room(user_name: :a, FIXED_ORDER: :a, RS_RESEND_DELAY: @RS_RESEND_DELAY)
      gate_leave_handle
      piece_move("77", "76")
      sleep(@RS_RESEND_DELAY)
      assert_no_text("同期失敗")
    end
  end
end
