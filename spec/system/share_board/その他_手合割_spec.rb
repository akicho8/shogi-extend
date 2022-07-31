require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      room_setup("my_room", "alice") # aliceが部屋を作る
    end
    b_block do
      room_setup("my_room", "bob")   # bobも同じ部屋に入る
    end
    a_block do
      preset_select("香落ち")
    end
    b_block do
      piece_move_o("22", "11", "☖1一角")
    end
  end
end
