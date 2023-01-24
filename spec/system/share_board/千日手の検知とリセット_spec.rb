require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "4回目の同一局面で指し手に千日手のラベルついてモーダルが発動して閉じれる" do
    visit_app
    sennichite_trigger
    action_assert_text("千日手")                 # 履歴に「千日手」のテキストが出ている
    assert_selector(".SennichiteModal")          # モーダルが存在する
    find(".SennichiteModal .close_handle").click # 「閉じる」
    assert_no_selector(".SennichiteModal")       # モーダルが閉じた
  end

  it "スライダーで2手目から1手目に戻しただけで千日手情報をリセットする" do
    visit_app
    king_move_up_down
    assert_system_variable("sennichite_cop.count", 4)
    sp_controller_click("previous")
    assert_system_variable("sennichite_cop.count", 0)
  end

  it "入室時にリセットする" do
    a_block do
      visit_app
      king_move_up_down
      assert_system_variable("sennichite_cop.count", 4)
      room_menu_open_and_input("test_room", "alice") # 入室
      assert_system_variable("sennichite_cop.count", 0)
    end
  end

  it "退室時にリセットする" do
    a_block do
      room_setup("test_room", "alice")
      king_move_up_down
      assert_system_variable("sennichite_cop.count", 4)
      room_leave
      assert_system_variable("sennichite_cop.count", 0)
    end
  end

  it "同期したとき相手もリセットする" do
    a_block { room_setup("test_room", "alice") }
    b_block { room_setup("test_room", "bob") }
    a_block do
      room_setup("test_room", "alice")
      king_move_up_down
      assert_system_variable("sennichite_cop.count", 4)
      room_leave
      assert_system_variable("sennichite_cop.count", 0)
    end
  end

  describe "反則設定が「したら負け」のときだけ発動する" do
    it "「したら負け」なので発動する" do
      visit_app(foul_behavior_key: "is_foul_behavior_auto")
      sennichite_trigger
      assert_selector(".SennichiteModal")
    end
    it "発動しない" do
      visit_app(foul_behavior_key: "is_foul_behavior_newbie")
      sennichite_trigger
      assert_no_selector(".SennichiteModal")
    end
    it "発動しない" do
      visit_app(foul_behavior_key: "is_foul_behavior_throw")
      sennichite_trigger
      assert_no_selector(".SennichiteModal")
    end
  end
end
