require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name => "a",
        :autoexec  => "order_self_only_auto_setup,avatar_input_modal_open_handle",
      })
    assert_avatar_input_modal_exist
    avatar_input_modal_close_handle
    assert_avatar_input_modal_none
  end
end
