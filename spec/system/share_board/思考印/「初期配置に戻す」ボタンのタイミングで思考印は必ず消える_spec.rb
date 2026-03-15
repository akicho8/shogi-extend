require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app
    piece_move_o("77", "76", "☗7六歩")       # 1手指す
    board_place("76").right_click             # 印をつける
    assert_mark_exist                         # 印はついている
    sidebar_open                              # サイドバーから
    find(".reflector_turn_zero_handle").click # 「初期配置に戻す」を押す
    sidebar_close
    assert_turn(0)
    assert_mark_none                          # 印は消えている
  end
end
