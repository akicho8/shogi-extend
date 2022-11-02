require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      visit_app({
          :room_code          => :test_room,
          :user_name    => "alice",
          :fixed_order_names  => "alice", # 白側に誰もいないため初手を指したあとで失敗する
          :fixed_order_state  => "to_o2_state",
          :SEND_SUCCESS_DELAY => -1, # 相手が応答しない
          :RETRY_DELAY        => 0,  # しかも0秒後に応答確認
          })
      piece_move_o("77", "76", "☗7六歩")             # 初手を指す
      assert_turn(1)
    end
  end
end
