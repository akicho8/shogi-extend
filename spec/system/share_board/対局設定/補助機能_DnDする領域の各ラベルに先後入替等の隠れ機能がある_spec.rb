require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name    => "a",
        :FIXED_MEMBER => "a,b,c,d",
        :FIXED_ORDER  => "a,b,c,d",
      })
    order_modal_open
    assert_order_team_one "ac", "bd"

    find(".is_team_black .OrderTeamOneTitle").click
    assert_text("aさんがチームを入れ替えました")
    assert_order_team_one "bd", "ac"

    find(".is_team_white .OrderTeamOneTitle").click
    assert_text("aさんがチームを入れ替えました")
    assert_order_team_one "ac", "bd"

    find(".is_team_watcher .OrderTeamOneTitle").click # 全員観戦にする
    assert_order_dnd_watcher "acbd"
  end
end
