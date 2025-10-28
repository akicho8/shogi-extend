require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room({
        :user_name                   => user_name,
        :FIXED_MEMBER          => "a,b",
        :FIXED_ORDER           => "a,b",
        "clock_box.initial_main_min" => 60,
      })
  end

  it "works" do
    window_a { case1(:a) }
    window_b { case1(:b)   }
    window_a do
      clock_start
      give_up_run
      assert_order_off_and_clock_stop # 順番がOFFになり、時計はSTOPになる
      assert_honpu_open_on         # 本譜のリンクがある
    end
    window_b do
      assert_order_off_and_clock_stop # b 側も同様の状態になっている
      assert_honpu_open_on         # 本譜のリンクがある
    end
  end
end
