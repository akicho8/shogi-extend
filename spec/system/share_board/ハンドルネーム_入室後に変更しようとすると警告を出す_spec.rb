require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room(user_name: :a, FIXED_ORDER: :a)
    sidebar_open
    menu_item_click("ハンドルネーム変更")
    assert_selector ".dialog.modal"
  end
end
