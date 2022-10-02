require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_app(legal_key: "loose")
    piece_move_o("19", "11", "☗1一香成")
  end
end
