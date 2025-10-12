require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_room(user_name: :alice, fixed_order: :alice)
    global_menu_open
    menu_item_click("ハンドルネーム変更")
    assert_text "いったん順番設定を無効にしてください"
  end
end
