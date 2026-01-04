require "#{__dir__}/shared_methods"

# このテストは 盤面操作禁止と警告_spec.rb があるのでいらない。
RSpec.xdescribe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room({
        :user_name => user_name,
        :FIXED_ORDER => "a,b",
      })
  end

  def case2
    window_a { case1(:a) }
    window_b { case1(:b)   }
    window_c { case1(:c) }
  end
  it "時計OFF順番設定ONでは検討をしていると思われる" do
    case2
    window_b do
      board_place("77").click
      assert_text("(今はaさんの手番です。みんなで盤をつついて検討する場合は順番設定を切ろう)")
    end
  end
  it "時計OFF順番設定ONでは検討をしていると思われるときに観戦者が操作しようとした" do
    case2
    window_c do
      board_place("77").click
      assert_text("(今はaさんの手番です。それにあなたは観戦者なんで触らんといてください。みんなで盤をつついて検討する場合は順番設定を切ろう)")
    end
  end
  it "時計ON順番設定ONは対局中と思われる" do
    case2
    window_b do
      clock_start
      board_place("77").click
      assert_text("(今はaさんの手番です)")
    end
  end
  it "順番設定で誰も参加していない(ユーザーの操作ではバリデーションがあるためこうはならない)" do
    visit_room({
        :user_name    => "a",
        :FIXED_MEMBER => "a",
        :FIXED_ORDER  => "a", # 順番設定で黒側に一人aがいる
        :body         => SfenGenerator.start_from(:white), # 後手から始まる
      })
    piece_move_o("33", "34", "☖3四歩") # a が代走する
    piece_move_o("77", "76", "☗7六歩") # a が自分の手を指す
  end
end
