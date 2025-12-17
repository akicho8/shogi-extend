require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name            => :a,
        :FIXED_ORDER          => :a, # 白側に誰もいないため初手を指したあとで失敗する
        :RESEND_SUCCESS_DELAY => -1, # 相手が応答しない
        :RESEND_DELAY         => 0,  # しかも0秒後に応答確認
        :room_after_create    => :cc_auto_start_10m,
      })
    piece_move_o("77", "76", "☗7六歩")   # 初手を指す
    assert_turn(1)
  end
end
