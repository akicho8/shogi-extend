require "#{__dir__}/helper"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "印モードの初期値は無効だが右上のペン印をクリックすると有効になる" do
    visit_app
    assert_var :think_mark_mode_p, "false"
    think_mark_toggle_button_click
    assert_var :think_mark_mode_p, "true"
  end

  it "クリックした升目に円と名前が出る" do
    visit_app(user_name: :alice, think_mark_mode_p: true)
    click_try_at_76
    assert_selector(".place_7_6 .ThinkMark .think_mark_circle_container")
    assert_selector(".place_7_6 .ThinkMark", text: :alice, exact_text: true)
  end

  it "印モードは無効でも副ボタンであれば印が出る" do
    visit_app
    find(".place_7_6").right_click
    assert_selector(".place_7_6 .ThinkMark")
  end

  it "持駒に印が出る" do
    visit_app(think_mark_mode_p: true, body: king_vs_king_sfen)
    find(".Membership.is_black .piece_P").click
    assert_selector(".Membership.is_black .ThinkMark")
  end

  it "名前が空なら円だけでる" do
    visit_app(user_name: "", think_mark_mode_p: true)
    click_try_at_76
    assert_selector(".place_7_6 .ThinkMark .think_mark_circle_container") # 円はあるが名前はない
    assert_no_selector(".place_7_6 .ThinkMark .think_mark_user_name")     # 名前が空ではなく名前欄自体がない
  end

  it "同じ場所を二度クリックすると印が消える" do
    visit_app(think_mark_mode_p: true)
    click_try_at_76
    assert_selector(".place_7_6 .ThinkMark")
    click_try_at_76
    assert_no_selector(".place_7_6 .ThinkMark")
  end

  it "複数の箇所に印が出る" do
    visit_app(think_mark_mode_p: true)
    place_click("77")
    place_click("76")
    assert_selector(".place_7_7 .ThinkMark")
    assert_selector(".place_7_6 .ThinkMark")
  end

  it "駒操作したら印が消える" do
    visit_app(think_mark_mode_p: true)
    assert_click_then_mark
    think_mark_toggle_button_click
    piece_move_o("77", "76", "☗7六歩")
    assert_no_selector(".place_7_6 .ThinkMark")
  end

  it "編集モードでは印が出ない" do
    visit_app(think_mark_mode_p: true, sp_mode: "edit")
    click_try_at_76
    assert_no_selector(".place_7_6 .ThinkMark")
  end

  it "引数で印を設定する / 同じ箇所に複数の名前が出る" do
    visit_app(think_mark_list_str: "7_6,a,0,7_6,b,1")
    assert_selector(".place_7_6 .ThinkMark .think_mark_user_name", text: "a", exact_text: true)
    assert_selector(".place_7_6 .ThinkMark .think_mark_user_name", text: "b", exact_text: true)
  end
end
