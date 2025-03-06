require "#{__dir__}/helper"

RSpec.describe "戻ると千日手の情報をリセットする", type: :system, share_board_spec: true do
  def case1
    piece_move("77", "76")
  end

  def case2
    find(".honpu_return_button").click
  end

  it "works" do
    visit_app(body: "position startpos")

    3.times do
      case1
      case2
    end

    case1                       # 同じ手の4度目

    assert_no_selector(".IllegalModal")  # 千日手のモーダルが発動していない
  end
end
