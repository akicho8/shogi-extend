require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app(room_key: "test_room", ng_word_check_p: true) # 合言葉を含むURLから来る
    room_auto_enter_but_confirm(:alice)
    piece_move_o("77", "76", "☗7六歩")
  end
end
