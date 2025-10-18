require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name => :a,
        :fixed_member => "a,b",
        :fixed_order => "a,b",
        :room_after_create => :cc_auto_start_10m
      })
    sleep(2)                                   # 2秒待つ
    piece_move_o("77", "76", "☗7六歩")        # 初手を指す
    action_log_row_of(0).text.match?(/[23]秒/) # 右側に "a 1 ☗7六歩 2秒" と表示している
  end
end
