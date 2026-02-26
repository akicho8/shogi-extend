require "#{__dir__}/helper"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room({
        :user_name                    => user_name,
        :think_mark_mode_p            => true,
        :think_mark_receive_scope_key => :tmrs_everyone,
      })
  end

  it "works" do
    # a と b はお互いに 55 に印をつける
    window_a { case1("a") }
    window_b { case1("b") }
    window_a { board_place("55").click }
    window_b { board_place("55").click }
    window_a { assert_selector(".place_5_5 .ThinkMark .think_mark_user_name", text: "a", exact_text: true) }
    window_b { assert_selector(".place_5_5 .ThinkMark .think_mark_user_name", text: "a", exact_text: true) }

    # a は escape を押して自分だけを消す
    window_a { Capybara.current_session.active_element.send_keys(:escape) }
    window_a { assert_no_selector(".place_5_5 .ThinkMark .think_mark_user_name", text: "a", exact_text: true) }
    window_b { assert_no_selector(".place_5_5 .ThinkMark .think_mark_user_name", text: "a", exact_text: true) }
  end
end
