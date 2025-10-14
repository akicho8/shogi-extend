require "#{__dir__}/helper"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app(body: "position startpos") # 棋譜がある状態で来たので
    assert_honpu_open_on                 # 「本譜」ボタンがあり
    assert_honpu_return_off              # 「戻る」ボタンはない
    piece_move("77", "76")               # そこで分岐する
    assert_turn(1)                       # 1手目になる
    assert_honpu_open_off                # そのとき「本譜」ボタンは消えて、
    assert_honpu_return_on               # 「戻る」ボタンが出る
    find(".honpu_return_button").click   # 「戻る」ボタンを押すと、
    assert_turn(0)                       # 0手目に戻る
    assert_honpu_open_on                 # その時「本譜」ボタンはあり、
    assert_honpu_return_off              # 「戻る」ボタンは消える
  end
end
