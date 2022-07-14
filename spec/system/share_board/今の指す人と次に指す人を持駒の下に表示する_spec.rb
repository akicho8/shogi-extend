require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_app(room_code: :my_room, force_user_name: "alice", ordered_member_names: "alice,bob,carol")
    assert_sp_player_names "alice", "bob" # 今:alice 次:bob
    piece_move_o("77", "76", "☗7六歩")
    assert_sp_player_names "carol", "bob" # 次:carol 今:bob
  end
end
