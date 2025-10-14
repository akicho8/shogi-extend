require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app
    assert_selector(".ShogiPlayer .b-slider-thumb", focused: true)
  end
end
