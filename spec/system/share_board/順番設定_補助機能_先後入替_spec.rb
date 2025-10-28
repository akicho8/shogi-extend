require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name    => "a",
        :FIXED_MEMBER => "a,b,c,d",
        :fixed_order  => "a,b,c,d",
      })
    os_modal_open
    assert_order_team_one "ac", "bd"
    find(".swap_handle").click
    assert_text("aさんが先後を入れ替えました")
    assert_order_team_one "bd", "ac"
  end
end
