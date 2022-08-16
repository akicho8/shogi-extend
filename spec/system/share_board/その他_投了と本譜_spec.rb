require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "投了" do
    a_block { visit_app(room_code: :my_room, force_user_name: "alice", ordered_member_names: "alice,bob", clock_box_initial_main_min: 60, clock_box_play_handle: true) }
    b_block { visit_app(room_code: :my_room, force_user_name: "bob",   ordered_member_names: "alice,bob", clock_box_initial_main_min: 60, clock_box_play_handle: true) }
    a_block do
      find("a", text: "投了", exact_text: true).click # ヘッダーの「投了」ボタンを押す
      find(:button, "本当に投了する").click           # モーダルが表示されるので本当に投了する
      assert_order_off_and_clock_stop                 # 順番がOFFになり、時計はSTOPになる
    end
    b_block do
      assert_order_off_and_clock_stop                 # bob 側も同様の状態になっている
    end
    a_block do
      find("a", text: "本譜", exact_text: true).click # 投了したことで「本譜」がヘッダーに出る
      has_selector?(".ActionLogJumpPreviewModal")     # クリックすると履歴と同じモーダルが出現する
    end
  end

  # 順番OFF 時計STOP
  def assert_order_off_and_clock_stop
    assert_system_variables("order_enable_p", "false")
    assert_system_variables("clock_box.current_status", "stop")
  end
end
