require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app
    sidebar_open
    menu_item_sub_menu_click("棋譜コピー")
    menu_item_click("KI2")
    assert_text("コピーしました")
  end
end
