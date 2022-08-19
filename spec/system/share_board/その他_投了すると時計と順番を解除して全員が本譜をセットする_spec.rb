require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block { visit_app(room_code: :my_room, force_user_name: "alice", ordered_member_names: "alice,bob", clock_box_initial_main_min: 60, clock_box_play_handle: true) }
    b_block { visit_app(room_code: :my_room, force_user_name: "bob",   ordered_member_names: "alice,bob", clock_box_initial_main_min: 60, clock_box_play_handle: true) }
    a_block do
      find("a", text: "投了", exact_text: true).click # ヘッダーの「投了」ボタンを押す
      find(:button, "本当に投了する").click           # モーダルが表示されるので本当に投了する
      assert_order_off_and_clock_stop                 # 順番がOFFになり、時計はSTOPになる
      assert_honpu_link_exist                         # 本譜のリンクがある
    end
    b_block do
      assert_order_off_and_clock_stop                 # bob 側も同様の状態になっている
      assert_honpu_link_exist                         # 本譜のリンクがある
    end
  end

  # 順番OFF 時計STOP
  def assert_order_off_and_clock_stop
    assert_system_variable("order_enable_p", "false")
    assert_system_variable("clock_box.current_status", "stop")
  end
end
