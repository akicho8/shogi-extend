require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    window_a do
      room_setup_by_user(:alice) # aliceが部屋を作る
    end
    window_b do
      room_setup_by_user(:bob)   # bobも同じ入退室
    end
    window_a do
      preset_select("香落ち")
    end
    window_b do
      piece_move_o("22", "11", "☖1一角")
    end
  end
end
