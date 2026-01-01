require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name            => :a,
        :FIXED_MEMBER         => "a,b",
        :FIXED_ORDER          => "a,b",
        :RESEND_SUCCESS_DELAY => -1, # 相手が応答しない
        :RESEND_DELAY         => 0,  # しかも0秒後に応答確認
        :RESEND_RETRY_MAX     => 1,  # 1回再送後に対局中断が押せる
        :room_after_create    => :cc_auto_start_10m,
      })

    piece_move_o("77", "76", "☗7六歩")                       # aが指す

    # 1回目のモーダル表示
    assert_selector(".resend_confirm_message", text: "bさんの反応がないので再送してください", exact_text: true) # しかしモーダルが出てbが応答しないのがわかる
    assert_selector(".resend_confirm_break_handle[disabled]") # このとき「対局中断」は disabled になっていて押せない
    find(".resend_confirm_execute_handle").click              # 1回目の再送をする
    assert_action_text("再送1")

    # 2回目のモーダル表示
    assert_selector(".resend_confirm_message", text: "bさんが抜けている場合は対局を中断後、順番設定から外して、対局時計を再開してください", exact_text: true) # しかしモーダルが出てbが応答しないのがわかる
    assert_selector(".resend_confirm_break_handle:not([disabled])") # このとき「対局中断」は disabled になっていない
    find(".resend_confirm_break_handle").click                      # 「対局を中断する」をクリックする
    assert_action_text("対局中断")                                  # 履歴にログが出ている
    assert_text "bさんが抜けた場合は順番設定から外して再開してください"
    assert_clock(:pause)                                            # 時計が一時停止している
  end
end
