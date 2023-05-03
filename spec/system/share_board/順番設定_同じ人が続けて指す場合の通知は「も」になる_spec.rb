require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_app({
        :room_code         => :test_room,
        :user_name         => "alice",
        :fixed_order_names => "alice",
        :fixed_order_state => "to_o1_state"
      })

    piece_move_o("77", "76", "☗7六歩")
    assert_system_variable(:next_turn_message, "次も、aliceさんの手番です")
  end
end
