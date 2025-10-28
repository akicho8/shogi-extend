require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
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
    assert_var("perpetual_cop.count", 4)
    sp_controller_click("previous")
    assert_var("perpetual_cop.count", 0)
  end

  it "入室時にリセットする" do
    window_a do
      visit_app
      king_move_up_down
      assert_var("perpetual_cop.count", 4)
      room_menu_open_and_input(:test_room, :a) # 入室
      assert_var("perpetual_cop.count", 0)
    end
  end

  it "退室時にリセットする" do
    window_a do
      room_setup_by_user(:a)
      king_move_up_down
      assert_var("perpetual_cop.count", 4)
      gate_leave_handle
      assert_var("perpetual_cop.count", 0)
    end
  end

  it "同期したとき相手もリセットする" do
    window_a { room_setup_by_user(:a) }
    window_b { room_setup_by_user(:b) }
    window_a do
      room_setup_by_user(:a)
      king_move_up_down
      assert_var("perpetual_cop.count", 4)
      gate_leave_handle
      assert_var("perpetual_cop.count", 0)
    end
  end

  describe "反則設定が「したら負け」のときだけ発動する" do
    it "「したら負け」なので発動する" do
      visit_app(foul_mode_key: "lose")
      perpetual_trigger
      assert_selector(".IllegalModal")
    end
    it "発動しない" do
      visit_app(foul_mode_key: "block")
      perpetual_trigger
      assert_no_selector(".IllegalModal")
    end
    it "発動しない" do
      visit_app(foul_mode_key: "ignore")
      perpetual_trigger
      assert_no_selector(".IllegalModal")
    end
  end

  it "千日手は判定が特殊だけど最後は二歩と同じ扱いになるので千日手のときも自動投了になる" do
    visit_room({
        :user_name         => "a",
        :FIXED_MEMBER      => "a",
        :fixed_order       => "a",
        :fixed_order_state => "to_o1_state",
        :room_after_create => :cc_auto_start_10m,
        :auto_resign_key   => :is_auto_resign_on,
        :RS_ENABLE         => false,
      })
    perpetual_trigger
    assert_selector(".IllegalModal", text: "千日手で☖の勝ち")
    illegal_modal_close
    assert_order_off  # 自動投了が有効だったため順番設定がOFFになっている
  end
end
