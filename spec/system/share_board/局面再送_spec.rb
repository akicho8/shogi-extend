require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1
    a_block do
      visit_app(room_code: :my_room, force_user_name: "alice", ordered_member_names: "alice,bob", RETRY_DELAY: @RETRY_DELAY, SEND_SUCCESS_DELAY: @SEND_SUCCESS_DELAY)
    end
    b_block do
      visit_app(room_code: :my_room, force_user_name: "bob", ordered_member_names: "alice,bob")
    end
    a_block do
      piece_move_o("77", "76", "☗7六歩")     # aliceが指した直後bobから応答OKが0.75秒ぐらいで帰ってくる
      sleep(@RETRY_DELAY)                     # 再送ダイアログが出るころまで待つ
    end
  end

  it "同期成功" do
    @SEND_SUCCESS_DELAY = 0 # 最速で応答する
    @RETRY_DELAY        = 1 # 1秒後に応答確認
    case1
    a_block do
      sync_failed_modal_closed    # 同期OKになっているので「同期失敗」ダイアログは出ない
    end
  end

  it "再送ダイアログ表示" do
    @SEND_SUCCESS_DELAY = -1 # 応答しない
    @RETRY_DELAY        = 0  # しかも0秒後に応答確認
    case1
    a_block do
      sync_failed_count(1)
      assert_text("次の手番のbobさんの反応がないので再送しますか？")

      find(:button, text: "再送する", exact_text: true).click
      action_assert_text("再送1")
      assert_text("再送1")
      sync_failed_count(2)

      find(:button, text: "再送する", exact_text: true).click
      action_assert_text("再送2")
      sync_failed_count(3)
    end
  end

  it "再送ダイアログ表示キャンセル" do
    @RETRY_DELAY        = 0 # 0秒後に返信をチェックするのですぐにダイアログ表示
    @SEND_SUCCESS_DELAY = 3 # しかし3秒後に成功したのでダイアログを消される
    case1
    a_block do
      sync_failed_count(1)
      sleep(@SEND_SUCCESS_DELAY) # ダイアログを消される
      sync_failed_modal_closed
    end
  end

  def sync_failed_count(n)
    assert_selector(".modal-card-title", text: "同期失敗 #{n}回目", exact_text: true, wait: 60)
  end

  def sync_failed_modal_closed
    assert_no_selector(".modal-card-title")
  end
end
