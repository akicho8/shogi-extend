require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    room_setup2(:alice)
    member_list_click_nth(1)
    assert_text("通信状況")
  end
end
