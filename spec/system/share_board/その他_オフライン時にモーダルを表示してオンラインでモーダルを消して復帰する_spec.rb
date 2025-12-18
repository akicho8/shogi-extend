require "#{__dir__}/shared_methods"

# このテストは実際のオフラインのテストとしては不十分だが、
# オフライン時にモーダルを表示してオンライン時にモーダルが消えるテストにはなっている
RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    def case1(user_name)
      visit_room({
          :user_name         => user_name,
          :FIXED_MEMBER      => "a,b,c",
          :FIXED_ORDER       => "a,b,c",
          :room_after_create => :cc_auto_start_10m,
          :RESEND_FEATURE        => false,
        })
    end
    window_a { case1(:a) }
    window_b { case1(:b) }
    window_a { piece_move_o("77", "76", "☗7六歩") } # a の指し手は、
    window_b { assert_turn(1) }                      # b に伝わっている
    window_a do
      find(".internet_off_trigger").click   # a が接続切れになる。
      assert_selector(".RoomRecreateModal") # オフラインになった旨を表示している
      assert_clock(:pause)                  # 時間切れで棋譜保存などが発動しないように時計はポーズしている
    end
    window_b do
      piece_move_o("33", "34", "☖3四歩") # a がオフラインの間に b は指す (テスト時には繋がっているためこの指し手は a に伝わってしまう)
    end
    window_a do
      find(".RoomRecreateModal .internet_on_trigger").click
      assert_no_selector(".RoomRecreateModal")
      assert_room_created
      assert_turn(2)
      assert_clock(:play)                  # b から復帰用の情報を受け取ったので a の時計は動いている
      assert_action_text("通信復旧")
    end
  end
end
