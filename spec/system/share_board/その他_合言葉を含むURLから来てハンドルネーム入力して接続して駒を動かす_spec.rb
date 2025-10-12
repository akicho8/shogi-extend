require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_app(room_key: "test_room", handle_name_validate_p: true) # 合言葉を含むURLから来る
    room_auto_enter_but_confirm
    piece_move_o("77", "76", "☗7六歩")
  end
end
