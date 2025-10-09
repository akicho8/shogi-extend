require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    room_key = SecureRandom.hex
    eval_code %(ShareBoard::Room.mock(room_key: "#{room_key}"))

    # 復元していない
    visit_room({:room_restore_key => :skip, room_key: room_key, user_name: :alice})
    assert_turn(0)
    assert_text("共有将棋盤")

    # 復元している
    visit_room({:room_restore_key => :run, room_key: room_key, user_name: :alice})
    assert_turn(4)
    assert_text("(room.name)")
  end
end
