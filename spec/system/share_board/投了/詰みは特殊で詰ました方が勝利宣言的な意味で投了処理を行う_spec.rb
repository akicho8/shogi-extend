require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :body              => SfenInfo.fetch("頭金で一手詰確認用").sfen,
        :user_name         => "a",
        :FIXED_MEMBER      => "a,b",
        :FIXED_ORDER       => "a,b",
        :room_after_create => :cc_auto_start_10m,
        :RESEND_FEATURE    => false,
      })
    stand_piece(:black, :G).click                                                           # ▲は金を持って
    board_place("52").click                                                                 # 頭金で詰ます
    assert_var(:ending_route_key, "er_auto_checkmate")                                      # エンディング = 詰みルート
    assert_order_off                                                                        # 順番設定は即OFFになっている
    assert_action_text("詰み")                                                              # 履歴に出る
    assert_selector(".EndingModal")                                                         # モーダルも出る
    assert_selector(".EndingModal .modal-card-head", text: "詰み", exact_text: true)        # モーダルのタイトル
    assert_selector(".EndingModal .modal-card-body", text: "☗の勝ちです", exact_text: true) # モーダルの本文
    ending_modal_close_handle                                                               # モーダルを閉じる
    assert_no_selector(".EndingModal")                                                      # モーダルは消える
  end
end
