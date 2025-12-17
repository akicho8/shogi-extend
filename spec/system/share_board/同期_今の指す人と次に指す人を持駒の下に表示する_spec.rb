require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name       => :a,
        :FIXED_ORDER     => "a,b,c",
        :RESEND_DELAY => -1,
        :room_after_create => :cc_auto_start_10m,
      })
    assert_sp_player_names :a, :b # 今:a 次:b
    piece_move_o("77", "76", "☗7六歩")
    assert_sp_player_names :c, :b # 次:c 今:b
  end
end
