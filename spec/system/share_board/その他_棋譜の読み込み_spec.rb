require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_app(room_code: :my_room, force_user_name: "alice")
    hamburger_click
    menu_item_click("棋譜の読み込み")
    find(".AnySourceReadModal textarea").set("68S", clear: :backspace)
    find(".AnySourceReadModal .submit_handle").click

    action_assert(0, "alice", "局面転送 #1")
    action_assert(1, "alice", "棋譜読込後(本筋)")
    assert_text "棋譜を読み込んで共有しました"
  end
end
