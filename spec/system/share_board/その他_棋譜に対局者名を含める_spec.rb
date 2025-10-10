require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room({
        user_name: user_name,
        fixed_order_names: "alice,bob",
        title: "(title)",
        :room_restore_key => :skip,
      })
  end

  it "部屋を立てていないときはURLから取得する" do
    visit_app(title: "(title)", black: "(alice)")
    global_menu_open
    menu_item_sub_menu_click("棋譜表示")
    switch_to_window_by do
      menu_item_click("KIF")
    end
    assert_text "棋戦：(title)"
    assert_text "先手：(alice)"
  end

  it "部屋を立てた後はメンバーリストから取得する" do
    window_a { case1(:alice) }
    window_b { case1(:bob)   }
    window_c { case1(:carol) }
    window_a do
      global_menu_open
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
    visit_app(black: :alice)
    piece_move_o("77", "76", "☗7六歩")
    action_log_row_of(0).click
    Capybara.within(".ActionLogModal") do
      assert_text(%("black": "alice")) # モーダル内のでデバッグプリントを見ている
    end
  end

  it "メンバーからコピーできる" do
    visit_room(user_name: :alice, fixed_order_names: "alice,bob")
    find(".player_names_copy_handle").click
    assert_text "コピーしました"
  end

  it "部屋に abcdef がいる順番が bdac のとき順番通り先手 ba 後手 dc の順の表記になり観戦は部屋にいる順になる" do
    visit_room({
        user_name: "a",
        fixed_member_names: "a,b,c,d,e,f",
        fixed_order_names: "b,d,a,c",
        handle_name_validate: false,
        title: "(title)",
        :room_restore_key => :skip,
      })
    global_menu_open
    menu_item_sub_menu_click("棋譜表示")
    switch_to_window_by do
      menu_item_click("KIF")
    end
    assert_text "棋戦：(title)"
    assert_text "先手：b, a"
    assert_text "後手：d, c"
    assert_text "観戦：e, f"
  end
end
