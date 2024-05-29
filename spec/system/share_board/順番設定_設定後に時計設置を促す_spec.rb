require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_app({
        :room_key            => :test_room,
        :user_name      => "a",
        :fixed_member_names   => "a",
        :fixed_order_state    => "to_o1_state",
        :handle_name_validate => "false",
      })
    global_menu_open
    os_modal_handle
    os_switch_toggle
    apply_button
    assert_text "次は時計を設置してください"
  end
end
