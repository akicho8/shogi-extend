require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app(autoexec: "board_preset_modal_open_handle")
    assert_board_preset_selected("平手")
    board_preset_arrow_button_click(:next)
    assert_board_preset_selected("香落ち")
    board_preset_arrow_button_click(:previous)
    assert_board_preset_selected("平手")
    board_preset_arrow_button_click(:previous)
    assert_board_preset_selected("石田流対決")
  end
end
