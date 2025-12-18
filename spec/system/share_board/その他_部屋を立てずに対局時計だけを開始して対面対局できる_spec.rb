require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app(**clock_box_params([0, 1, 0, 0]))
    clock_start
    piece_move_o("77", "76", "☗7六歩")
    assert_text("時間切れで☗の勝ち")
  end
end
