require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_app({
        :room_key            => :test_room,
        :user_name            => "a",
        :fixed_member_names   => "a",
        :fixed_order_names    => "a",
        :fixed_order_state    => "to_o1_state",
        :handle_name_validate => "false",
        :autoexec_room_create_after => "os_modal_open_handle",
      })

    drag_to_watch("dnd_both", 0) # a を観戦に移動

    os_submit_button_click
    assert_text "誰も参加していません"
  end
end
