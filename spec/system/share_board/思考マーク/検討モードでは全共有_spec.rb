require "#{__dir__}/helper"

RSpec.describe "検討モードでは全共有", type: :system, share_board_spec: true do
  def case1(user_name)
    visit_app({
        :room_key                     => :test_room,
        :user_name                    => user_name,
        :handle_name_validate         => "false",
        :think_mark_mode_p            => "true",
        :think_mark_receive_scope_key => :tmrs_watcher_only,
      })
  end

  it "works" do
    a_block { case1("a") }
    b_block { case1("b") }
    Capybara.using_wait_time(0) { debugger }
    a_block { assert_click_then_mark }
    b_block { assert_click_then_mark }
    a_block do
      assert_selector(".place_7_6 .ThinkMark", text: "a", exact_text: true)
      assert_selector(".place_7_6 .ThinkMark", text: "b", exact_text: true)
    end
  end
end
