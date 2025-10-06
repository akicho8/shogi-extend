require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :room_key             => :test_room,
        :user_name            => "a",
        :fixed_member_names   => "a",
        :fixed_order_state    => "to_o1_state",
        :handle_name_validate => "false",
      })
    os_modal_open
    os_switch_toggle
    os_submit_button_click
    assert_text "次は時計を設置してください"
  end
end
