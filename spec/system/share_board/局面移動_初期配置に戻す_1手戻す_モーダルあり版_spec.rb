require "#{__dir__}/sb_support_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "初期配置に戻す" do
    setup_a_b_turn2
    window_a do
      sidebar_open
      find(".turn_change_to_zero_modal_open_handle").click     # 「初期配置に戻す」モーダルを開く
      find(".apply_button").click                              # 「N手目まで戻る」
      assert_turn(0)                                           # 0手に戻っている
    end
    window_b do
      assert_turn(0)                                           # b側も0手に戻っている
    end
  end

  it "1手戻す" do
    setup_a_b_turn2
    window_a do
      sidebar_open
      find(".turn_change_to_previous_modal_open_handle").click # 「1手戻す」モーダルを開く
      find(".apply_button").click                              # 「N手目まで戻る」
      assert_turn(1)                                           # 1手目に戻っている
    end
    window_b do
      assert_turn(1)                                           # b側も1手に戻っている
    end
  end

  it "初期配置に戻すダイアログの中で局面を調整する" do
    setup_a_b_turn2
    window_a do
      sidebar_open
      find(".turn_change_to_zero_modal_open_handle").click     # 「初期配置に戻す」モーダルを開く
      Capybara.within(".TurnChangeModal") do
        assert_text("局面 #0")                                 # 初期配置に戻すため初期値は0手目になっているが
        find(".button.next").click                             # 「>」で
        assert_text("局面 #1")                                 # 1手目に進める
      end
      find(".apply_button").click                              # 「N手目まで戻る」
      assert_turn(1)                                           # 0手目ではなく1手目に戻っている
    end
  end
end
