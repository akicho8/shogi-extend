require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a { room_setup_by_user(:a) }
    window_b { room_setup_by_user(:b) }
    window_a { board_preset_select("香落ち") }
    window_b { piece_move_o("22", "11", "☖1一角") }
  end
end
