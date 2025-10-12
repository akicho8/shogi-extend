require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name         => :alice,
        :fixed_order_names => "alice,bob,carol",
        :RS_RESEND_DELAY   => -1,
      })
    assert_sp_player_names :alice, :bob # 今:alice 次:bob
    piece_move_o("77", "76", "☗7六歩")
    assert_sp_player_names :carol, :bob # 次:carol 今:bob
  end
end
