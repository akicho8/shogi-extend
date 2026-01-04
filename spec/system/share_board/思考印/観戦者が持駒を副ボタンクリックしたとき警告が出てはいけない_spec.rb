require "#{__dir__}/helper"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room({
        :body              => SfenInfo.fetch("盤上は玉のみで他持駒").sfen,
        :user_name         => user_name,
        :FIXED_MEMBER      => "a,b,c",
        :FIXED_ORDER       => "a,b",
        :room_after_create => :cc_auto_start_10m,
        :think_mark_mode_p => false,
      })
  end

  it "works" do
    window_a { case1(:a) }
    window_b { case1(:b) }
    window_c { case1(:c) }
    window_c do
      stand_piece(:black, :P).right_click                      # 観戦者がaさんの持駒を右クリックしたとき
      assert_selector(".Membership.is_black .ThinkMark")       # 印が出る
      assert_no_text "cさんは観戦者なので触らんといてください" # そして警告は出ない

      board_place("76").right_click                            # 観戦者が盤を右クリックしたとき
      assert_selector(".place_7_6 .ThinkMark")                 # 印が出る
      assert_no_text "cさんは観戦者なので触らんといてください" # そして警告は出ない
    end
  end
end
