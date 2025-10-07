require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_room(room_key: :test_room, user_name: "alice")
    assert_member_exist("alice")
    assert_no_text "部屋のリンクをコピーしますか？", wait: 10
  end
end
