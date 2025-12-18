require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app
    sidebar_open
    menu_item_click("棋譜URLコピー")
    assert_text("棋譜再生用のURLをコピーしました")
  end
end
