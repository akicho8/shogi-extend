require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1
    visit_app({
        :room_code            => :my_room,
        :fixed_user_name      => "1",
        :fixed_member_names   => "1,2,3,4",
        :fixed_order_names    => "1,2,3,4",
        :fixed_order_state    => "to_o2_state",
        :handle_name_validate => "false",
        :autoexec             => "os_modal_handle",
      })
  end

  it "works" do
    case1
    assert_order_team_one "dnd_black", "1,3"
    assert_order_team_one "dnd_white", "2,4"
    find(".swap_handle").click
    assert_text("1さんが先後を入れ替えました", wait: 60)
    assert_order_team_one "dnd_black", "2,4"
    assert_order_team_one "dnd_white", "1,3"
  end
end
