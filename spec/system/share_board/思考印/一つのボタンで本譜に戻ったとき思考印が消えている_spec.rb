require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app(body: "76歩")                        # 棋譜の引数があるのでこれを本譜とする (1手のみの棋譜)
    piece_move("33", "34")                         # 分岐する
    board_place("55").right_click                  # 印をつける
    assert_mark_exist                              # 印がある
    find(".honpu_direct_return_handle").click      # 「本譜に戻る」相当のボタンを押す
    assert_mark_none                               # 印は消えている
  end
end
