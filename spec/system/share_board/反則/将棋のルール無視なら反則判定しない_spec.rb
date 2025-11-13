require "#{__dir__}/../shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app(legal_key: "loose")
    piece_move_o("19", "11", "☗1一香成") # 駒ワープの指摘をスルーしている
    piece_move_o("17", "16", "☗1六歩")   # 連続で先手が動かせている
  end
end
