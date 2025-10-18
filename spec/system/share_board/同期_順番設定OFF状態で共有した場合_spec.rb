require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name)
    room_setup_by_user(user_name)
  end

  it "works" do
    window_a do
      case1(:a)
      piece_move_o("17", "16", "☗1六歩") # aは一人で初手を指した
    end
    window_b do
      case1(:b)                       # a と同じ部屋の合言葉を設定する
      assert_member_exist(:a)
      assert_member_exist(:b)
    end
    window_a do
      assert_member_exist(:a)
      assert_member_exist(:b)
    end
    window_b do
      piece_move_o("33", "34", "☖3四歩") # bは2手目の後手を指せる
    end
    window_a do
      assert_text("☖3四歩")              # aの画面にもbの指し手の符号が表示されている
    end
  end
end
