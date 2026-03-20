require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name    => "a",
        :FIXED_MEMBER => "a,b",
      })
    sidebar_open
    order_modal_open_handle
    order_switch_on
    order_submit_handle
    assert_text "次は時計を設置しよう"
  end
end
