require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    room_key = SecureRandom.hex

    sfen_info = SfenInfo["相全駒手番△"]
    eval_code %(ShareBoard::Room.mock(room_key: "#{room_key}", sfen: "#{sfen_info.sfen}"))

    # 復元していない
    visit_room({room_key: room_key, user_name: :a})
    assert_turn(0)
    assert_text("共有将棋盤")

    # 復元している
    visit_room({room_restore_feature_p: true, room_key: room_key, user_name: :a})
    assert_turn(sfen_info.turn)
    assert_text("(room.name)")
  end
end
