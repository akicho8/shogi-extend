require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    eval_code %(ShareBoard.setup(force: true))
    eval_code %(ShareBoard::Room.mock(room_key: "dev_room1"))

    # 復元していない
    visit_room({:room_restore_key => :skip, room_key: "dev_room1", user_name: "alice"})
    assert_turn(0)
    assert_text("共有将棋盤")

    # 復元している
    visit_app({:room_restore_key => :enable, room_key: "dev_room1", user_name: "alice"})
    assert_turn(4)
    assert_text("(room.name)")
  end
end
