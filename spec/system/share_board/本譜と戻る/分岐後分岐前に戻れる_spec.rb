require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app(body: "position startpos")      # 棋譜がある状態で来たので
    assert_honpu_open_on                      # 「本譜」ボタンがあり
    assert_honpu_return_disabled              # 「戻る」ボタンは disabled で存在する
    piece_move("77", "76")                    # そこで分岐する
    assert_history_text("変化")
    assert_turn(1)                            # 1手目になる
    assert_turn_max(1)
    assert_honpu_open_on                      # そのとき「本譜」ボタンはそのままで
    assert_honpu_return_active                # 「戻る」ボタンが有効になる
    find(".honpu_return_button").click        # 「戻る」ボタンを押すと、
    assert_turn(0)                            # 0手目に戻る
    assert_turn_max(0)                        # 2手目までの棋譜を破棄して完全に0手目までの棋譜に戻っている
    assert_text("本譜の初期配置に戻しました") # 「本譜の」となるの重要
    assert_history_text("本譜")
    assert_honpu_open_on                      # その時「本譜」ボタンはあり、
    assert_honpu_return_disabled              # 「戻る」ボタンは disabled に戻る
  end
end
