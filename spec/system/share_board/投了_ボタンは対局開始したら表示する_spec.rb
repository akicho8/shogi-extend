require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :room_key           => :test_room,
        :user_name          => "alice",
        :fixed_member_names => "alice,bob",
        :fixed_order_names  => "alice,bob",
        :autoexec           => "cc_auto_start",
      })
    assert_give_up_button
  end
end
