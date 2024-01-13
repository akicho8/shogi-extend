require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "未ログイン" do
    visit_app
    global_menu_open
    menu_item_click("メール送信")
    assert_text("Twitter でログインする")
  end

  it "ログイン済み" do
    login
    visit_app
    global_menu_open
    menu_item_click("メール送信")
    assert_text("shogi.extend@gmail.com 宛に送信しました")
  end
end
