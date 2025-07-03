require "#{__dir__}/helper"

RSpec.describe "順番設定直後の自動設定", type: :system, share_board_spec: true do
  def case1(user_name, think_mark_mode_p)
    visit_app({
        :room_key             => :test_room,
        :user_name            => user_name,
        :fixed_member_names   => "a,b,c",
        :fixed_order_names    => "a,b",
        :handle_name_validate => "false",
        :fixed_order_state    => :to_o2_state,
        :think_mark_mode_p    => think_mark_mode_p,
      })
  end

  it "順番設定モーダルから明示的に共有したタイミングでのみ印モードが対局者はOFFで観戦者はONになる" do
    # 変化したか分からないため想定値の逆の値にしておく
    a_block { case1("a", "true")  }
    b_block { case1("b", "true")  }
    c_block { case1("c", "false") }

    # 順番設定を適用する
    a_block do
      os_modal_open
      os_modal_force_submit
      os_modal_close
    end

    a_block { assert_system_variable :think_mark_mode_p, false }
    b_block { assert_system_variable :think_mark_mode_p, false }
    c_block { assert_system_variable :think_mark_mode_p, true  } # 観戦者だけ印ONになる
  end
end
