require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_app
    global_menu_open
    menu_item_sub_menu_click("棋譜コピー")
    menu_item_click("KI2")
    assert_text("コピーしました")
  end
end
