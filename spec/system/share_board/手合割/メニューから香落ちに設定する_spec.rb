require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a { room_setup_by_user(:a) }
    window_b { room_setup_by_user(:b) }
    window_a do
      sidebar_open
      menu_item_click("手合割")
      board_preset_select("香落ち")
      board_preset_apply
    end
    window_b do
      piece_move_o("22", "11", "☖1一角")
    end
  end
end
