require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "初期配置に戻す" do
    setup_alice_bob_turn2
    a_block do
      global_menu_open
      find(".force_sync_turn_zero_handle").click # 「初期配置に戻す」モーダルを開く
      assert_turn(0)                                # 0手に戻っている
    end
    b_block do
      assert_turn(0)            # bob側も0手に戻っている
    end
  end

  it "1手戻す" do
    setup_alice_bob_turn2
    a_block do
      global_menu_open
      find(".force_sync_turn_previous_handle").click # 「1手戻す」モーダルを開く
      assert_turn(1)                                           # 1手目に戻っている
    end
    b_block do
      assert_turn(1)            # bob側も1手に戻っている
    end
  end
end
