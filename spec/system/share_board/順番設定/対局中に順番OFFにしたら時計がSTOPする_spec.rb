require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name => "a",
        :FIXED_MEMBER => "a,b",
        :FIXED_ORDER => "a,b",
        :room_after_create => :cc_auto_start_10m,
      })
    assert_order_on
    assert_clock_on
    order_set_off
    assert_order_off_and_clock_stop
  end
end
