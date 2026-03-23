require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name, think_mark_mode_p)
    room_setup_by_user(user_name, {think_mark_mode_p: think_mark_mode_p})
  end

  it "対局設定モーダルから明示的に共有したタイミングでのみ印モードが対局者はOFFで観戦者はONになる" do
    # 変化したか分からないため想定値の逆の値にしておく
    window_a { case1("a", "true")  }
    window_b { case1("b", "true")  }
    window_c { case1("c", "false") }

    # 対局設定を適用する
    window_a do
      sidebar_open
      order_modal_open_handle
      order_switch_on
      drag_to_watch(:is_team_black, 1) # c を観戦に移動する。つまり a vs b で観戦 c とする
      order_submit_handle
      sidebar_close
    end

    window_a { assert_var :think_mark_mode_p, false }
    window_b { assert_var :think_mark_mode_p, false }
    window_c { assert_var :think_mark_mode_p, true  } # 観戦者だけ印ONになる
  end
end
