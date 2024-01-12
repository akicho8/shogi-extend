require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      room_setup("test_room", "alice")
      piece_move_o("17", "16", "☗1六歩")     # aliceは一人で初手を指した
    end
    b_block do
      room_setup("test_room", "bob")          # alice と同じ部屋の合言葉を設定する
      assert_member_exist("alice")
      assert_member_exist("bob")
    end
    a_block do
      assert_member_exist("alice")
      assert_member_exist("bob")
    end
    b_block do
      piece_move_o("33", "34", "☖3四歩")     # bobは2手目の後手を指せる
    end
    a_block do
      assert_text("☖3四歩")                 # aliceの画面にもbobの指し手の符号が表示されている
    end
  end
end
