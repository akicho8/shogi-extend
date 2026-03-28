require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app
    sidebar_open
    Clipboard.write("")
    find(".current_short_url_copy_handle").click
    assert_text("短縮版の棋譜URLをコピーしました")
    assert_clipboard("http://localhost:3000/u/")
  end
end
