require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name            => "a",
        :fixed_member   => "a",
        :fixed_order_state    => "to_o1_state",
      })
    os_modal_open
    os_switch_toggle
    os_submit_button_click
    assert_text "次は時計を設置してください"
  end
end
