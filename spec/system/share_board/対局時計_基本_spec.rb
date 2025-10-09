require "#{__dir__}/shared_methods"

RSpec.describe "対局時計_基本", type: :system, share_board_spec: true do
  before do
    @INITIAL_SEC = 5
  end

  it "works" do
    window_a do
      room_setup_by_user(:alice)                  # aliceが部屋を作る
    end
    window_b do
      room_setup_by_user(:bob)                    # bobも同じ入退室
    end
    window_a do
      clock_open
    end
    window_b do
      assert_clock_on                                   # 同期してbob側にも設置されている
    end
    window_a do
      clock_box_form_set(:black, 0, @INITIAL_SEC, 0, 0) # aliceが時計を設定する
      find(:button, :class => "play_button").click      # 開始
      cc_modal_close                                    # 閉じる (ヘッダーに置いている)
    end
    window_b do
      assert_white_read_sec(@INITIAL_SEC)               # bob側は秒読みが満タン
    end
    window_a do
      piece_move_o("27", "26", "☗2六歩")                # 初手を指す
      assert_clock_active_white                         # 時計を同時に押したので後手がアクティブになる
    end
    window_b do
      assert_clock_active_white                         # bob側も後手がアクティブになっている
      sleep(@INITIAL_SEC)                               # ここでは3秒ぐらいになってるけどさらに秒読みぶん待つ
      assert_white_read_sec(0)                          # 秒読みが0になっている
      assert_text("時間切れで☗の勝ち")                  # 時間切れのダイアログの表示(1回目)
      find(".button.is-primary").click                  # それを閉じる
    end
    window_a do
      assert_text("時間切れで☗の勝ち")                  # alice側でも時間切れのダイアログが表示されている
      find(".button.is-primary").click                  # それを閉じる
    end
    window_b do
      piece_move_o("33", "34", "☖3四歩")                # bobは時間切れになったがそれを無視して指した
      assert_white_read_sec(@INITIAL_SEC)               # すると秒読みが復活した
      assert_clock_active_black                         # 時計も相手に切り替わった
    end
    window_a do
      assert_clock_active_black                         # alice側もaliceがアクティブになった
      assert_white_read_sec(@INITIAL_SEC)               # bobの秒読みが復活している
      piece_move_o("77", "76", "☗7六歩")                # aliceは3手目を指した
      assert_clock_active_white                         # bobに時計が切り替わった
    end
    window_b do
      assert_clock_active_white                         # bob側もbob側にの時計に切り替わった
      sleep(@INITIAL_SEC)                               # bobは再び時間切れになるまで待った
      assert_text("時間切れで☗の勝ち")                  # 2度目のダイアログが出た
      cc_timeout_modal_close                            # いったん閉じないと assert_white_read_sec が失敗するため
      assert_white_read_sec(0)                          # また0時間切れになった
    end
    window_a do
      assert_text("時間切れで☗の勝ち")                  # alice側でもダイアログが出た
    end
  end
end
