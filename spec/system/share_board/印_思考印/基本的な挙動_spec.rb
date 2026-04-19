require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "印モードの初期値は無効だが右上のペン印をクリックすると有効になる" do
    visit_app
    assert_var :think_mark_mode_p, "false"
    think_mark_toggle_button_click
    assert_var :think_mark_mode_p, "true"
  end

  it "クリックした升目に円と名前が出る" do
    visit_app(user_name: :a, think_mark_mode_p: true)
    board_place("76").click
    assert_selector(".place_7_6 .ThinkMarkLayer .general_mark_effect_container")
    assert_selector(".place_7_6 .ThinkMarkLayer", text: :a, exact_text: true)
  end

  it "印モードは無効でも副ボタンであれば印が出る" do
    visit_app
    find(".place_7_6").right_click
    assert_selector(".place_7_6 .ThinkMarkLayer")
  end

  it "持駒に印が出る" do
    visit_app(think_mark_mode_p: true, body: SfenInfo.fetch("盤上は玉のみで他持駒").sfen)
    stand_piece(:black, :P).click
    assert_selector(".Membership.is_black .ThinkMarkLayer")
  end

  it "名前が空なら円だけでる" do
    visit_app(user_name: "", think_mark_mode_p: true)
    board_place("76").click
    assert_selector(".place_7_6 .ThinkMarkLayer .general_mark_effect_container") # 円はあるが名前はない
    assert_no_selector(".place_7_6 .ThinkMarkLayer .general_mark_user_name")     # 名前が空ではなく名前欄自体がない
  end

  it "同じ場所を二度クリックすると印が消える" do
    visit_app(think_mark_mode_p: true)
    board_place("76").click
    assert_selector(".place_7_6 .ThinkMarkLayer")
    board_place("76").click
    assert_no_selector(".place_7_6 .ThinkMarkLayer")
  end

  it "複数の箇所に印が出る" do
    visit_app(think_mark_mode_p: true)
    board_place("77").click
    board_place("76").click
    assert_selector(".place_7_7 .ThinkMarkLayer")
    assert_selector(".place_7_6 .ThinkMarkLayer")
  end

  it "駒操作したら印が消える" do
    visit_app(think_mark_mode_p: true)
    assert_click_then_think_mark
    think_mark_toggle_button_click
    piece_move_o("77", "76", "☗7六歩")
    assert_no_selector(".place_7_6 .ThinkMarkLayer")
  end

  it "編集モードでは印が出ない" do
    visit_app(think_mark_mode_p: true, sp_mode: "edit")
    board_place("76").click
    assert_no_selector(".place_7_6 .ThinkMarkLayer")
  end

  it "引数で印を設定する / 同じ箇所に複数の名前が出る" do
    visit_app(think_mark_collection_str: "7_6,a,0,7_6,b,1")
    assert_selector(".place_7_6 .ThinkMarkLayer .general_mark_user_name", text: "a", exact_text: true)
    assert_selector(".place_7_6 .ThinkMarkLayer .general_mark_user_name", text: "b", exact_text: true)
  end
end
