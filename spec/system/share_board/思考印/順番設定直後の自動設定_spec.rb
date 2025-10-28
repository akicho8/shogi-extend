require "#{__dir__}/helper"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name, think_mark_mode_p)
    visit_room({
        :user_name         => user_name,
        :FIXED_MEMBER      => "a,b,c",
        :fixed_order       => "a,b",
        :think_mark_mode_p => think_mark_mode_p,
      })
  end

  it "順番設定モーダルから明示的に共有したタイミングでのみ印モードが対局者はOFFで観戦者はONになる" do
    # 変化したか分からないため想定値の逆の値にしておく
    window_a { case1("a", "true")  }
    window_b { case1("b", "true")  }
    window_c { case1("c", "false") }

    # 順番設定を適用する
    window_a do
      os_modal_open
      os_modal_force_submit
      os_modal_close
    end

    window_a { assert_var :think_mark_mode_p, false }
    window_b { assert_var :think_mark_mode_p, false }
    window_c { assert_var :think_mark_mode_p, true  } # 観戦者だけ印ONになる
  end
end
