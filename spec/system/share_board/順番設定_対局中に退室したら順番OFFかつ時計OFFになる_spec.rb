require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name => "a",
        :FIXED_MEMBER => "a,b",
        :fixed_order => "a,b",
        :room_after_create => :cc_auto_start_10m,
      })
    assert_order_on
    assert_clock_on
    gate_leave_handle
    assert_order_off
    assert_clock_off
  end
end
