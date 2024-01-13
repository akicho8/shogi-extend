require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit "/share-board"
    assert_text("共有将棋盤")
  end
end
