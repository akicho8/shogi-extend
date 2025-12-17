require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1
    window_a { visit_room(user_name: :a, FIXED_ORDER: "a,b", RESEND_DELAY: @RESEND_DELAY, RESEND_SUCCESS_DELAY: @RESEND_SUCCESS_DELAY, room_after_create: :cc_auto_start_10m) }
    window_b { visit_room(user_name: :b, FIXED_ORDER: "a,b", room_after_create: :cc_auto_start_10m) }
    window_a do
      piece_move_o("77", "76", "☗7六歩")     # aが指した直後bから応答OKが0.75秒ぐらいで帰ってくる
      sleep(@RESEND_DELAY)                 # 再送モーダルが出るころまで待つ
    end
  end

  it "同期成功" do
    @RESEND_DELAY         = 1 # 1秒後に応答確認
    @RESEND_SUCCESS_DELAY = 0 # 最速で応答する
    case1
    window_a do
      assert_no_selector(".ResendConfirmModal")    # 同期OKになっているので「同期失敗」ダイアログは出ない
    end
  end

  it "再送モーダル表示" do
    @RESEND_DELAY         = 0  # しかも0秒後に応答確認
    @RESEND_SUCCESS_DELAY = -1 # 応答しない
    case1
    window_a do
      assert_resend_failed_count(1)
      assert_text("bさんの反応がないので再送してください")

      find(".resend_confirm_execute_handle").click # 再送する
      assert_action_text("再送1")
      assert_text("再送1")
      assert_resend_failed_count(2)

      find(".resend_confirm_execute_handle").click # 再送する
      assert_action_text("再送2")
      assert_resend_failed_count(3)
    end
  end

  it "いったん再送モーダル表示を出したが数秒後にbは指したため再送モーダルを消す" do
    @RESEND_DELAY         = 0 # 0秒後に返信をチェックするのですぐにダイアログ表示
    @RESEND_SUCCESS_DELAY = 3 # しかし3秒後に成功したのでダイアログを消される
    case1
    window_a do
      assert_resend_failed_count(1)
      sleep(@RESEND_SUCCESS_DELAY) # ダイアログを消される
      assert_no_selector(".ResendConfirmModal")
    end
  end

  it "再送モーダル表示中にbが落ちたことに気づいて順番設定から除外して同期したタイミングでモーダルとタイマーを消す" do
    @RESEND_DELAY  = 0  # 0秒後に返信をチェックするのですぐにダイアログ表示
    @RESEND_SUCCESS_DELAY = -1 # 応答しない
    case1
    window_a do
      find(:button, text: "bさんを順番から外す", exact_text: true).click
      assert_no_selector(".ResendConfirmModal")
    end
  end
end
