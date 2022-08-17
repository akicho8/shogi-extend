require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "部屋を立てていないときはURLから取得する" do
    visit_app(title: "(title)", black: "(alice)")
    hamburger_click
    menu_item_sub_menu_click("棋譜表示")
    switch_to_window_by do
      menu_item_click("KIF")
    end
    assert_text "棋戦：(title)"
    assert_text "先手：(alice)"
  end

  it "部屋を立てた後はメンバーリストから取得する" do
    a_block do
      visit_app(room_code: :my_room, force_user_name: "alice", ordered_member_names: "alice,bob", title: "(title)")
    end
    b_block do
      visit_app(room_code: :my_room, force_user_name: "bob")
    end
    c_block do
      visit_app(room_code: :my_room, force_user_name: "carol")
    end
    a_block do
      hamburger_click
      menu_item_sub_menu_click("棋譜表示")
      switch_to_window_by do
        menu_item_click("KIF")
      end
      assert_text "棋戦：(title)"
      assert_text "先手：alice"
      assert_text "後手：bob"
      assert_text "観戦：carol"
    end
  end

  it "操作履歴にも含んでいる" do
    a_block do
      visit_app(black: "alice")
      piece_move_o("77", "76", "☗7六歩")
      action_log_row_of(0).click
      Capybara.within(".ActionLogShowModal") do
        assert_text('"black": "alice"') # デバッグ情報の表示を見ている
      end
    end
  end

  it "メンバーからコピーできる" do
    visit_app(room_code: :my_room, force_user_name: "alice", ordered_member_names: "alice,bob", title: "(title)")
    find(".player_names_copy_handle").click
    assert_text "コピーしました"
  end
end
