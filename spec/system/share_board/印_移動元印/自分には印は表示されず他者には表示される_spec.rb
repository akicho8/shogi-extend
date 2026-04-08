require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a { room_setup_by_user(:a) }
    window_b { room_setup_by_user(:b) }
    window_a { board_place("59").click }      # a が玉を持ち上げる
    window_a { assert_origin_mark_none }      # a の印はついていない
    window_b { assert_origin_mark_exist }     # b に印はついている
  end
end
