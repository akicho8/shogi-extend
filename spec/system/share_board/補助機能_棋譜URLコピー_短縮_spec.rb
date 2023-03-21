require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_app
    hamburger_click
    Clipboard.write("")
    menu_item_click("棋譜URLコピー (短縮)")
    assert_text("棋譜再生用の短縮URLをコピーしました")
    is_asserted_by { Clipboard.read == "https://tinyurl.com/2qqme7jk" }
  end
end
