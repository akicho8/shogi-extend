require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room({
        :room_key                   => :test_room,
        :user_name                   => user_name,
        :fixed_member_names          => "alice,bob",
        :fixed_order_names           => "alice,bob",
        "clock_box.initial_main_min" => 60,
      })
  end

  it "works" do
    a_block { case1("alice") }
    b_block { case1("bob")   }
    a_block do
      clock_start
      give_up_run
      assert_order_off_and_clock_stop # 順番がOFFになり、時計はSTOPになる
      assert_honpu_open_on         # 本譜のリンクがある
    end
    b_block do
      assert_order_off_and_clock_stop # bob 側も同様の状態になっている
      assert_honpu_open_on         # 本譜のリンクがある
    end
  end
end
