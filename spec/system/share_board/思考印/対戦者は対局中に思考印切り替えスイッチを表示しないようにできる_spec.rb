require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name, think_mark_switch_visibility_key)
    visit_room({
        :user_name                        => user_name,
        :FIXED_MEMBER                     => "a,b,c",
        :FIXED_ORDER                      => "a,b",
        :room_after_create                => :cc_auto_start_10m,
        :think_mark_switch_visibility_key => think_mark_switch_visibility_key,
      })
  end

  it "対局者のとき対局中でも表示する" do
    window_a { case1(:a, :tmsv_visible) }
    window_b { case1(:b, :tmsv_visible) }
    window_c { case1(:c, :tmsv_visible) }
    window_a { assert_selector(".think_mark_toggle_button_click_handle") }
    window_b { assert_selector(".think_mark_toggle_button_click_handle") }
    window_c { assert_selector(".think_mark_toggle_button_click_handle") }
  end

  it "対局者のとき対局中は表示しない" do
    window_a { case1(:a, :tmsv_hidden) }
    window_b { case1(:b, :tmsv_hidden) }
    window_c { case1(:c, :tmsv_hidden) }
    window_a { assert_no_selector(".think_mark_toggle_button_click_handle") }
    window_b { assert_no_selector(".think_mark_toggle_button_click_handle") }
    window_c { assert_selector(".think_mark_toggle_button_click_handle") } # 観戦者には表示している
  end
end
