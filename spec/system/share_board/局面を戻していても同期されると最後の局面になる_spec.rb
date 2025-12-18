require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a do
      room_setup_by_user(:a)                     # aが部屋を作る
    end
    window_b do
      room_setup_by_user(:b)                       # bも同じ入退室
    end
    window_a do
      piece_move_o("77", "76", "☗7六歩")                 # aが指す
    end
    window_b do
      piece_move_o("33", "34", "☖3四歩")                 # bが指す
      sp_controller_click("first")                       # bは最初の局面に戻した
    end
    window_a do
      piece_move_o("27", "26", "☗2六歩")                 # aが指す
    end
    window_b do
      piece_move_o("83", "84", "☖8四歩")                 # 最後の局面になっている(bの手番になっている)のでbが指せる
    end
  end
end
