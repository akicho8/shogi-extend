require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app(body: "position startpos")

    piece_move("77", "76")
    find(".honpu_direct_return_handle").click

    piece_move("77", "76")
    find(".honpu_direct_return_handle").click

    piece_move("77", "76")
    find(".honpu_direct_return_handle").click

    piece_move("77", "76")      # 同じ手の4度目

    assert_no_selector(".EndingModal")  # 千日手のモーダルが発動していない
  end
end
