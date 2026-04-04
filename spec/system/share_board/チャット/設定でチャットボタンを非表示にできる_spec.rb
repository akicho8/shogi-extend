require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app
    assert_selector(".chat_modal_open_handle")

    visit_app(chat_button_visibility_key: "cbv_hidden")
    assert_no_selector(".chat_modal_open_handle")
  end
end
