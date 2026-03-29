require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app
    piece_move_o("77", "76", "☗7六歩")
    piece_move_o("33", "34", "☖3四歩")
    assert_turn(2)
    history_items_at(1).click                         # 上から2番目、つまり1手目の履歴を開く
    find(".time_machine_modal_apply_handle").click    # 「N手目まで戻る」
    assert_turn(1)                                    # 1手目に変更されている
  end
end
