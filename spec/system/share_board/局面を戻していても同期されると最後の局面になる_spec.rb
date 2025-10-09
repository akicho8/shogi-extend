require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    window_a do
      room_setup2(:alice)                     # aliceが部屋を作る
    end
    window_b do
      room_setup2(:bob)                       # bobも同じ入退室
    end
    window_a do
      piece_move_o("77", "76", "☗7六歩")                 # aliceが指す
    end
    window_b do
      piece_move_o("33", "34", "☖3四歩")                 # bobが指す
      sp_controller_click("first")                       # bobは最初の局面に戻した
    end
    window_a do
      piece_move_o("27", "26", "☗2六歩")                 # aliceが指す
    end
    window_b do
      piece_move_o("83", "84", "☖8四歩")                 # 最後の局面になっている(bobの手番になっている)のでbobが指せる
    end
  end
end
