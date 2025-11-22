require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app(chat_content_scale_key: "ccs_large", autoexec: "chat_modal_open_handle")
    assert_selector(".ChatModal.is-full-screen")
  end
end
