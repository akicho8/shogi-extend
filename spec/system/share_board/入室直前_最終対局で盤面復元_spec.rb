require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    eval_code %(ShareBoard.setup(force: true))
    eval_code %(ShareBoard::Room.mock)

    # 復元していない
    visit_app({room_latest_state_loader_p: "false", room_key: "dev_room1", user_name: "alice"})
    assert_turn(0)

    # 復元している
    visit_app({room_latest_state_loader_p: "true", room_key: "dev_room1", user_name: "alice"})
    assert_turn(4)
  end
end
