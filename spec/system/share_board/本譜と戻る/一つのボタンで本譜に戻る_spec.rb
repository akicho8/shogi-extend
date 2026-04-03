require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app(body: "position startpos")      # 棋譜がある状態で来たので
    assert_honpu_open_on                      # 「本譜」ボタンがあり
    assert_honpu_return_off                   # 「本譜に戻る」はない
    piece_move("77", "76")                    # そこで分岐する
    assert_history_text("変化")               # 履歴に「変化」がある
    assert_turn(1)                            # 1手目になる
    assert_turn_max(1)                        # 最大手数も1
    assert_honpu_open_off                     # そのとき「本譜」ボタンは消えて
    assert_honpu_return_on                    # 「戻る」ボタンが有効になる
    find(".honpu_direct_return_handle").click # 「戻る」ボタンを押すと、
    assert_turn(0)                            # 0手目に戻る
    assert_turn_max(0)                        # 2手目までの棋譜を破棄して完全に0手目までの棋譜に戻っている
    assert_text("分岐前に戻しました")         # 専用のメッセージになっている
    assert_history_text("本譜")
    assert_honpu_open_on                      # その時「本譜」ボタンはあり、
    assert_honpu_return_off                   # 「戻る」ボタンは消える
  end
end
