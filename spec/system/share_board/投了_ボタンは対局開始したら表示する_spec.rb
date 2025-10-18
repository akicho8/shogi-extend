require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name          => :a,
        :fixed_member => "a,b",
        :fixed_order  => "a,b",
        :room_create_after_action => :cc_auto_start,
      })
    assert_give_up_button
  end
end
