require "#{__dir__}/helper"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app(body: "position startpos") # 棋譜がある状態で来たので
    assert_honpu_open_on                 # 「本譜」ボタンがあり
    assert_honpu_return_disabled         # 「戻る」ボタンは disabled で存在する
    piece_move("77", "76")               # そこで分岐する
    assert_action_text("変化")
    assert_turn(1)                       # 1手目になる
    assert_honpu_open_on                 # そのとき「本譜」ボタンはそのままで
    assert_honpu_return_active          # 「戻る」ボタンが有効になる
    find(".honpu_return_button").click   # 「戻る」ボタンを押すと、
    assert_turn(0)                       # 0手目に戻る
    assert_action_text("本譜")
    assert_honpu_open_on                 # その時「本譜」ボタンはあり、
    assert_honpu_return_disabled         # 「戻る」ボタンは disabled に戻る
  end
end
