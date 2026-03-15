require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app(body: "76歩")                        # 棋譜の引数があるのでこれを本譜とする (1手のみの棋譜)
    assert_honpu_open_on                           # 本譜になっている
    piece_move("33", "34")                         # そこから続いて2手目を指す (本譜は変化せず1手目の状態で記録している)
    assert_turn(2)                                 # 盤上だけが2手目まで進んでいる
    assert_turn_max(2)                             # 棋譜の長さも2になっている
    find(".honpu_modal_open_handle").click               # 「本譜」ボタンを押して
    find(".time_machine_modal_apply_handle").click # 最後の局面に戻る
    assert_turn(1)                                 # すると1手目にもどる (ここまでは従来通り)
    assert_turn_max(1)                             # 棋譜の長さも1手目に戻っているのが重要で、つまり2手目34歩の棋譜を持った状態で1手目を指さない
  end
end
