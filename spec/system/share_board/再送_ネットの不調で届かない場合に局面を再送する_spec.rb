require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1
    window_a do
      visit_room(user_name: :a, FIXED_ORDER: "a,b", RS_RESEND_DELAY: @RS_RESEND_DELAY, RS_SUCCESS_DELAY: @RS_SUCCESS_DELAY, room_after_create: :cc_auto_start_10m)
    end
    window_b do
      visit_room(user_name: :b, FIXED_ORDER: "a,b", room_after_create: :cc_auto_start_10m)
    end
    window_a do
      piece_move_o("77", "76", "☗7六歩")     # aが指した直後bから応答OKが0.75秒ぐらいで帰ってくる
      sleep(@RS_RESEND_DELAY)                 # 再送モーダルが出るころまで待つ
    end
  end

  it "同期成功" do
    @RS_RESEND_DELAY  = 1 # 1秒後に応答確認
    @RS_SUCCESS_DELAY = 0 # 最速で応答する
    case1
    window_a do
      assert_rs_modal_closed    # 同期OKになっているので「同期失敗」ダイアログは出ない
    end
  end

  it "再送モーダル表示" do
    @RS_RESEND_DELAY  = 0  # しかも0秒後に応答確認
    @RS_SUCCESS_DELAY = -1 # 応答しない
    case1
    window_a do
      assert_rs_faild_count(1)
      assert_text("次の手番のbさんの通信状況が悪いため再送してください")

      find(:button, text: "再送する", exact_text: true).click
      assert_action_text("再送1")
      assert_text("再送1")
      assert_rs_faild_count(2)

      find(:button, text: "再送する", exact_text: true).click
      assert_action_text("再送2")
      assert_rs_faild_count(3)
    end
  end

  it "いったん再送モーダル表示を出したが数秒後にbは指したため再送モーダルを消す" do
    @RS_RESEND_DELAY  = 0 # 0秒後に返信をチェックするのですぐにダイアログ表示
    @RS_SUCCESS_DELAY = 3 # しかし3秒後に成功したのでダイアログを消される
    case1
    window_a do
      assert_rs_faild_count(1)
      sleep(@RS_SUCCESS_DELAY) # ダイアログを消される
      assert_rs_modal_closed
    end
  end

  it "再送モーダル表示中にbが落ちたことに気づいて順番設定から除外して同期したタイミングでモーダルとタイマーを消す" do
    @RS_RESEND_DELAY  = 0  # 0秒後に返信をチェックするのですぐにダイアログ表示
    @RS_SUCCESS_DELAY = -1 # 応答しない
    case1
    window_a do
      find(:button, text: "bさんを順番から外す", exact_text: true).click
      assert_rs_modal_closed
    end
  end

  def assert_rs_faild_count(n)
    assert_selector(".modal-card-title", text: "同期失敗 #{n}回目", exact_text: true, wait: 30)
  end

  def assert_rs_modal_closed
    assert_no_selector(".modal-card-title")
  end
end
