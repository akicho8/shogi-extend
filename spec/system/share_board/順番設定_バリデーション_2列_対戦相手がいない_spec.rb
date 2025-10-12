require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name            => "a",
        :fixed_member_names   => "a",
        :fixed_order_names    => "a",
        :fixed_order_state    => "to_o2_state",
      })

    os_modal_open
    os_switch_toggle
    os_submit_button_click
    assert_text "各チームに最低1人入れてください"

    drag_to_watch("dnd_black", 0) # a を観戦に移動

    os_submit_button_click
    assert_text "誰も参加していません"
  end
end
