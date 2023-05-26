require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "4回目の同一局面で指し手に千日手のラベルついてモーダルが発動して閉じれる" do
    visit_app
    perpetual_trigger
    assert_action_text("千日手")              # 履歴に「千日手」のテキストが出ている
    assert_selector(".IllegalModal")          # モーダルが存在する
    illegal_modal_close
    assert_no_selector(".IllegalModal")       # モーダルが閉じた
  end

  it "スライダーで2手目から1手目に戻しただけで千日手情報をリセットする" do
    visit_app
    king_move_up_down
    assert_system_variable("perpetual_cop.count", 4)
    sp_controller_click("previous")
    assert_system_variable("perpetual_cop.count", 0)
  end

  it "入室時にリセットする" do
    a_block do
      visit_app
      king_move_up_down
      assert_system_variable("perpetual_cop.count", 4)
      room_menu_open_and_input("test_room", "alice") # 入室
      assert_system_variable("perpetual_cop.count", 0)
    end
  end

  it "退室時にリセットする" do
    a_block do
      room_setup("test_room", "alice")
      king_move_up_down
      assert_system_variable("perpetual_cop.count", 4)
      room_leave
      assert_system_variable("perpetual_cop.count", 0)
    end
  end

  it "同期したとき相手もリセットする" do
    a_block { room_setup("test_room", "alice") }
    b_block { room_setup("test_room", "bob") }
    a_block do
      room_setup("test_room", "alice")
      king_move_up_down
      assert_system_variable("perpetual_cop.count", 4)
      room_leave
      assert_system_variable("perpetual_cop.count", 0)
    end
  end

  describe "反則設定が「したら負け」のときだけ発動する" do
    it "「したら負け」なので発動する" do
      visit_app(illegal_behavior_key: "is_illegal_behavior_auto")
      perpetual_trigger
      assert_selector(".IllegalModal")
    end
    it "発動しない" do
      visit_app(illegal_behavior_key: "is_illegal_behavior_newbie")
      perpetual_trigger
      assert_no_selector(".IllegalModal")
    end
    it "発動しない" do
      visit_app(illegal_behavior_key: "is_illegal_behavior_throw")
      perpetual_trigger
      assert_no_selector(".IllegalModal")
    end
  end

  it "千日手は判定が特殊だけど最後は二歩と同じ扱いになるので千日手のときも自動投了になる" do
    visit_app({
        :room_code            => :test_room,
        :user_name            => "a",
        :fixed_member_names   => "a",
        :fixed_order_names    => "a",
        :handle_name_validate => "false",
        :fixed_order_state    => "to_o1_state",
        :clock_auto_start     => "true",
        :auto_resign_key      => "is_auto_resign_on",
        :RETRY_FUNCTION       => "false",
      })
    perpetual_trigger
    assert_selector(".IllegalModal", text: "千日手で☖の勝ち！")
    illegal_modal_close
    assert_order_off  # 自動投了が有効だったため順番設定がOFFになっている
  end
end
