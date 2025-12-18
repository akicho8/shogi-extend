require "#{__dir__}/sb_support_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app
    assert_selector(".CustomShogiPlayer .b-slider-thumb", focused: true)
  end
end
