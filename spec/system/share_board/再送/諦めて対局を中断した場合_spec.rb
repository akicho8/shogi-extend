require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name            => :a,
        :FIXED_MEMBER         => "a,b",
        :FIXED_ORDER          => "a,b",
        :RESEND_SUCCESS_DELAY => -1, # 相手が応答しない
        :RESEND_DELAY         => 0,  # しかも0秒後に応答確認
        :room_after_create    => :cc_auto_start_10m,
      })
    piece_move_o("77", "76", "☗7六歩")                   # aが指す
    assert_text("bさんの反応がないので再送してください") # しかしbが応答しない
    find(".resend_confirm_break_handle").click           # 「対局を中断する」をクリックする
    assert_action_text("対局中断")                       # 履歴にログが出ている
    assert_text("再開してください")                      # 時計を再開すればよいと伝えている
    assert_clock(:pause)                                 # 時計が一時停止している
  end
end
