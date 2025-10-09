require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(user_name)
    room_setup_by_user(user_name, :room_restore_key => :skip)
  end

  it "works" do
    window_a do
      case1(:alice)
      piece_move_o("17", "16", "☗1六歩") # aliceは一人で初手を指した
    end
    window_b do
      case1(:bob)                       # alice と同じ部屋の合言葉を設定する
      assert_member_exist(:alice)
      assert_member_exist(:bob)
    end
    window_a do
      assert_member_exist(:alice)
      assert_member_exist(:bob)
    end
    window_b do
      piece_move_o("33", "34", "☖3四歩") # bobは2手目の後手を指せる
    end
    window_a do
      assert_text("☖3四歩")              # aliceの画面にもbobの指し手の符号が表示されている
    end
  end
end
