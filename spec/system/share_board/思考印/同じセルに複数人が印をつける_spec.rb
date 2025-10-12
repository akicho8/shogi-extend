require "#{__dir__}/helper"

RSpec.describe "同じセルに複数人が印をつける", type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room({
        :user_name                    => user_name,
        :think_mark_mode_p            => true,
        :think_mark_receive_scope_key => :tmrs_watcher_only, # 観戦者のみ(もともと初期値はこれだけどあえて指定)
      })
  end

  it "works" do
    window_a { case1("a") }
    window_b { case1("b") }
    window_a { assert_click_then_mark }
    window_b { assert_click_then_mark }

    # 検討中は think_mark_receive_scope_key に関係なく全員が受信する
    window_a do
      assert_selector(".place_7_6 .ThinkMark .think_mark_user_name", text: "a", exact_text: true)
      assert_selector(".place_7_6 .ThinkMark .think_mark_user_name", text: "b", exact_text: true)
    end
  end
end
