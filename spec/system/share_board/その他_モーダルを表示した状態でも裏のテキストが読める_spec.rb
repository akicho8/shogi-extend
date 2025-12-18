require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app
    sidebar_open
    gate_modal_open_handle
    assert_turn(0)
  end
end
