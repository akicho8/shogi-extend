require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_app
    global_menu_open
    menu_item_click("棋譜URLコピー")
    assert_text("棋譜再生用のURLをコピーしました")
  end
end
