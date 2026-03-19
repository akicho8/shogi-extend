require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app
    sidebar_open
    find(".SbControlPanel .cc_modal_open_handle").click
    assert_text("まず部屋に入ろう")
  end
end
