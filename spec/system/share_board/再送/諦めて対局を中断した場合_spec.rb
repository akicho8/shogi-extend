require "#{__dir__}/../shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name         => :a,
        :FIXED_MEMBER      => "a,b",
        :FIXED_ORDER       => "a,b",
        :RS_SUCCESS_DELAY  => -1, # 相手が応答しない
        :RS_RESEND_DELAY   => 0,  # しかも0秒後に応答確認
        :room_after_create => :cc_auto_start_10m,
      })
    piece_move_o("77", "76", "☗7六歩")                                 # aが指す
    assert_text("次の手番のbさんの通信状況が悪いため再送してください") # しかしbが応答しない
    find(".rs_break_handle").click                                     # 「対局を中断する」をクリックする
    assert_action_text("対局中断")                                     # 履歴にログが出ている
    assert_clock(:pause)                                               # 時計が一時停止している
  end
end
