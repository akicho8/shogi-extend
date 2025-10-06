require "#{__dir__}/shared_methods"

RSpec.describe "対局時計_設定の操作中に値を同期する", type: :system, share_board_spec: true do
  CC_INPUT_DEBOUNCE_DELAY = 0.5

  def case1(user_name)
    visit_app2({
        :room_key            => :test_room,
        :user_name            => user_name,
        :fixed_member_names   => "a,b",
        :fixed_order_names    => "a,b",
        :fixed_order_state    => "to_o2_state",
        :handle_name_validate => "false",
      })
  end

  it "works" do
    a_block { case1("a") }
    b_block { case1("b") }
    a_block do
      clock_open
      clock_box_form_set(:black, 1, 2, 3, 4)   # alice が時計を操作し終わると 0.5 秒に
    end
    b_block do
      assert_text "cc_params:[[1,2,3,4]]", wait: CC_INPUT_DEBOUNCE_DELAY + 5 # bob の画面に反映する
    end
  end
end
