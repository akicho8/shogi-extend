require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  before do
    visit_app
    hamburger_click
  end
  it "works" do
    menu_item_click("棋譜URLコピー")
    assert_text("棋譜再生用のリンクをコピーしました")
  end
  it "works" do
    menu_item_click("棋譜URLコピー (短縮)")
    assert_text("棋譜再生用の短縮URLをコピーしました")
  end
end
