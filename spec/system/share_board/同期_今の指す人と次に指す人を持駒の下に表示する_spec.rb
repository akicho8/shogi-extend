require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name       => :a,
        :fixed_order     => "a,b,c",
        :RS_RESEND_DELAY => -1,
        :room_create_after_action => :cc_auto_start_longtime,
      })
    assert_sp_player_names :a, :b # 今:a 次:b
    piece_move_o("77", "76", "☗7六歩")
    assert_sp_player_names :c, :b # 次:c 今:b
  end
end
