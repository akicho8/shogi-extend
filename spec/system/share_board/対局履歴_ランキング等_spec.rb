require "#{__dir__}/shared_methods"

RSpec.describe "対局履歴_ランキング等", type: :system, share_board_spec: true do
  it "works" do
    eval_code %(ShareBoard.setup(force: true))
    eval_code %(ShareBoard::Room.mock)

    visit2 "/share-board/dashboard", room_key: "dev_room1"
    assert_text("順位")
    assert_text("alice")
    assert_text("bob")
    assert_text("carol")
  end
end
