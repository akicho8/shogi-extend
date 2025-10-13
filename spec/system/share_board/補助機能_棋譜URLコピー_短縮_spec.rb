require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_app
    sidebar_open
    Clipboard.write("")
    menu_item_click("棋譜URLコピー (短縮)")
    assert_text("棋譜再生用の短縮URLをコピーしました")
    # 2023-04-06 から
    # curl https://tinyurl.com/api-create.php?url=http://localhost:3000/
    # とすると
    # Error
    # を返すようになってしまった
    # assert { Clipboard.read == "Error" }
    # 2023-04-12 から直った
    assert_clipboard("tinyurl")
  end
end
