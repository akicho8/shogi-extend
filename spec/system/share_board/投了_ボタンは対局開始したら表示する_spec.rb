require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name          => :alice,
        :fixed_member => "alice,bob",
        :fixed_order  => "alice,bob",
        :room_create_after_action => :cc_auto_start,
      })
    assert_give_up_button
  end
end
