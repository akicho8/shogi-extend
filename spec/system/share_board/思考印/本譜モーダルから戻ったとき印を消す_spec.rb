require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app(body: "76歩")                        # 棋譜の引数があるのでこれを本譜とする (1手のみの棋譜)
    board_place("76").right_click                  # 印をつける
    assert_mark_exist                              # 印がある
    find(".honpu_modal_open_handle").click         # 「本譜」ボタンを押す
    find(".time_machine_modal_apply_handle").click # 最後の局面に戻る
    assert_mark_none                               # 印は消えている
  end
end
