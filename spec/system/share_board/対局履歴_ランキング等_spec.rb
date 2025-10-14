require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    room_key = SecureRandom.hex
    eval_code %(ShareBoard::Room.mock(room_key: "#{room_key}"))

    visit_to("/share-board/dashboard", room_key: room_key)
    assert_text("順位")
    assert_text(:alice)
    assert_text(:bob)
    assert_text(:carol)
  end
end
