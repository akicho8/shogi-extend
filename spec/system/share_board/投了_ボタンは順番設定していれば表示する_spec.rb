require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_app({
        :room_code          => :test_room,
        :fixed_user_name    => "alice",
        :fixed_member_names => "alice,bob",
        :fixed_order_names  => "alice,bob",
      })
    assert_give_up_button
  end
end
