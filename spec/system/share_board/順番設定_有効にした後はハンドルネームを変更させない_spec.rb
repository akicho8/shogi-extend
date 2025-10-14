require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room(user_name: :alice, fixed_order: :alice)
    sidebar_open
    menu_item_click("ハンドルネーム変更")
    assert_text "いったん順番設定を無効にしてください"
  end
end
