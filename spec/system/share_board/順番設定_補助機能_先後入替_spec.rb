require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1
    visit_room({
        :user_name            => "1",
        :fixed_member   => "1,2,3,4",
        :fixed_order    => "1,2,3,4",
        :fixed_order_state    => "to_o2_state",
      })
    os_modal_open
    os_switch_toggle
  end

  it "works" do
    case1
    assert_order_team_one "13", "24"
    find(".swap_handle").click
    assert_text("1さんが先後を入れ替えました", wait: 30)
    assert_order_team_one "24", "13"
  end
end
