require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    room_setup_by_user(:alice)
    member_list_click_nth(1)
    assert_text("通信状況")
  end
end
