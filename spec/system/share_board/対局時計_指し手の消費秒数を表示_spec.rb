require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_room(user_name: :alice)
    clock_start_force
    sleep(2)                                   # 2秒待つ
    piece_move_o("77", "76", "☗7六歩")         # 初手を指す
    action_log_row_of(0).text.match?(/[23]秒/) # 右側に "alice 1 ☗7六歩 2秒" と表示している
    # assert_text は overflow-x: hidden で隠れている場合があるためランダムに失敗する
  end
end
