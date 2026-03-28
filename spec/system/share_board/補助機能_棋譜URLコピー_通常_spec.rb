require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app
    sidebar_open
    find(".current_long_url_copy_handle").click
    assert_text("通常版の棋譜URLをコピーしました")
  end
end
