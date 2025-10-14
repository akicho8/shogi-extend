require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name          => :alice,
        :fixed_member => "alice,bob",
        :fixed_order  => "alice,bob",
        :room_enter_autoexec => :cc_auto_start,
      })
    assert_give_up_button
  end
end
