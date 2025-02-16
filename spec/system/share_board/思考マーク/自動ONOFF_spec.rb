require "#{__dir__}/helper"

RSpec.describe "自動ONOFF", type: :system, share_board_spec: true do
  def case1(user_name, think_mark_mode_p)
    visit_app({
        :room_key                     => :test_room,
        :user_name                    => user_name,
        :fixed_member_names           => "a,b,c",
        :fixed_order_names            => "a,b",
        :handle_name_validate         => "false",
        :fixed_order_state            => :to_o2_state,
        # :think_mark_mode_p            => think_mark_mode_p,
      })
  end

  it "順番設定を明示的に共有したタイミングで観戦者は自動的に印ONになり、対局者はOFFになる" do
    a_block { case1("a", "true")  }
    b_block { case1("b", "true")  }
    c_block { case1("c", "false") }
    Capybara.using_wait_time(0) { debugger }
  end
end
