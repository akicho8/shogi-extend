require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      room_setup("my_room", "alice")                     # aliceが部屋を作る
    end
    b_block do
      room_setup("my_room", "bob")                       # bobも同じ部屋に入る
    end
    a_block do
      piece_move_o("77", "76", "☗7六歩")                 # aliceが指す
    end
    b_block do
      piece_move_o("33", "34", "☖3四歩")                 # bobが指す
      sp_controller_click("first")                       # bobは最初の局面に戻した
    end
    a_block do
      piece_move_o("27", "26", "☗2六歩")                 # aliceが指す
    end
    b_block do
      piece_move_o("83", "84", "☖8四歩")                 # 最後の局面になっている(bobの手番になっている)のでbobが指せる
    end
  end
end
