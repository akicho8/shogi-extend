require "#{__dir__}/sb_support_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    room_key = SecureRandom.hex
    eval_code %(ShareBoard::Room.mock(room_key: "#{room_key}"))

    visit_to("/share-board/dashboard", room_key: room_key)
    assert_text("順位")
    assert_text(:a)
    assert_text(:b)
    assert_text(:c)
  end
end
