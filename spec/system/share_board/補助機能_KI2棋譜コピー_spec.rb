require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app
    sidebar_open
    find(".kifu_copy_handle.ki2").click
    assert_text("コピーしました")
  end
end
