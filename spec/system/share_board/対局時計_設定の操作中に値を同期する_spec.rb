require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  CC_INPUT_DEBOUNCE_DELAY = 0.5 # mod_clock_box.js の定数と合わせる

  def case1(user_name)
    visit_room({
        :user_name    => user_name,
        :FIXED_MEMBER => "a,b",
        :fixed_order  => "a,b",
      })
  end

  it "works" do
    window_a { case1(:a) }
    window_b { case1(:b) }
    window_a do
      clock_open
      clock_box_form_set(:black, 1, 2, 3, 4) # a が時計を操作し終わると CC_INPUT_DEBOUNCE_DELAY 秒に
      sleep(CC_INPUT_DEBOUNCE_DELAY)
    end
    window_b do
      assert_var :cc_params, "[[1,2,3,4]]"   # b 側に同期している
    end
  end
end
