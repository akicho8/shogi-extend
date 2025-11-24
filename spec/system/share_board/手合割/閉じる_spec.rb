require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app(autoexec: "board_preset_modal_open_handle")
    assert_selector(".BoardPresetModal")
    board_preset_close
    assert_no_selector(".BoardPresetModal")
  end
end
