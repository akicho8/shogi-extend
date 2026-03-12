require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room({
        :body              => sfen,
        :foul_mode_key     => "takeback",
        :user_name         => user_name,
        :FIXED_MEMBER      => "a,b",
        :FIXED_ORDER       => "a,b",
        :room_after_create => :cc_auto_start_10m,
      })
  end

  it "works" do
    window_a { case1(:a) }
    window_b { case1(:b) }

    window_a { double_pawn! }         # aに二歩をする

    window_a { assert_turn(1) }       # aの盤は1手目を反映している (重要)
    window_a { assert_clock(:pause) } # 時計は一時停止している

    window_b { assert_turn(1) }       # b 側も同様
    window_b { assert_clock(:pause) }

    window_a { find(".illegal_takeback_modal_submit_handle_takeback").click } # a は「待った」する

    window_a { assert_turn(0) }      # 0手目に戻っている
    window_a { assert_clock(:play) } # 時計は再開している

    window_b { assert_turn(0) }      # b 側も同様
    window_b { assert_clock(:play) }
  end
end
