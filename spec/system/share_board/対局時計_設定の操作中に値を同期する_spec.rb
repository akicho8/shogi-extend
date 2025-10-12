require "#{__dir__}/shared_methods"

RSpec.describe "対局時計_設定の操作中に値を同期する", type: :system, share_board_spec: true do
  CC_INPUT_DEBOUNCE_DELAY = 0.5

  def case1(user_name)
    visit_room({
        :user_name            => user_name,
        :fixed_member   => "a,b",
        :fixed_order    => "a,b",
        :fixed_order_state    => "to_o2_state",
      })
  end

  it "works" do
    window_a { case1("a") }
    window_b { case1("b") }
    window_a do
      clock_open
      clock_box_form_set(:black, 1, 2, 3, 4)   # alice が時計を操作し終わると 0.5 秒に
    end
    window_b do
      assert_text "cc_params:[[1,2,3,4]]", wait: CC_INPUT_DEBOUNCE_DELAY + 5 # bob の画面に反映する
    end
  end
end
