require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "初期配置に戻す" do
    setup_alice_bob_turn2
    a_block do
      global_menu_open
      find(".turn_change_to_zero_modal_open_handle").click # 「初期配置に戻す」モーダルを開く
      find(".apply_button").click                          # 「N手目まで戻る」
      assert_turn(0)                                       # 0手に戻っている
    end
    b_block do
      assert_turn(0)            # bob側も0手に戻っている
    end
  end

  it "1手戻す" do
    setup_alice_bob_turn2
    a_block do
      global_menu_open
      find(".turn_change_to_previous_modal_open_handle").click # 「1手戻す」モーダルを開く
      find(".apply_button").click                              # 「N手目まで戻る」
      assert_turn(1)                                           # 1手目に戻っている
    end
    b_block do
      assert_turn(1)            # bob側も1手に戻っている
    end
  end

  it "初期配置に戻すダイアログの中で局面を調整する" do
    setup_alice_bob_turn2
    a_block do
      global_menu_open
      find(".turn_change_to_zero_modal_open_handle").click # 「初期配置に戻す」モーダルを開く
      Capybara.within(".TurnChangeModal") do
        assert_text("局面 #0")                          # 初期配置に戻すため初期値は0手目になっているが
        find(".button.next").click                      # 「>」で
        assert_text("局面 #1")                          # 1手目に進める
      end
      find(".apply_button").click                       # 「N手目まで戻る」
      assert_turn(1)                                    # 0手目ではなく1手目に戻っている
    end
  end
end
