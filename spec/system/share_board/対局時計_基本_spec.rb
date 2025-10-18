require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  before do
    @INITIAL_SEC = 5
  end

  it "works" do
    window_a { room_setup_by_user(:a) }
    window_b { room_setup_by_user(:b) }
    window_a do
      order_set_on
      clock_open
    end
    window_b do
      assert_order_on
      assert_clock_on                                   # 同期してb側にも設置されている
    end
    window_a do
      clock_box_form_set(:black, 0, @INITIAL_SEC, 0, 0) # aが時計を設定する
      find(:button, :class => "play_button").click      # 開始
      cc_modal_close                                    # 閉じる (ヘッダーに置いている)
    end
    window_b do
      assert_white_read_sec(@INITIAL_SEC)               # b側は秒読みが満タン
    end
    window_a do
      piece_move_o("27", "26", "☗2六歩")                # 初手を指す
      assert_clock_active_white                         # 時計を同時に押したので後手がアクティブになる
    end
    window_b do
      assert_clock_active_white                         # b側も後手がアクティブになっている
      sleep(@INITIAL_SEC)                               # ここでは3秒ぐらいになってるけどさらに秒読みぶん待つ
      assert_white_read_sec(0)                          # 秒読みが0になっている
      assert_text("時間切れで☗の勝ち")                  # 時間切れのダイアログの表示(1回目)
      cc_timeout_modal_close                            # それを閉じる
    end
    window_a do
      assert_text("時間切れで☗の勝ち")                  # a側でも時間切れのダイアログが表示されている
      cc_timeout_modal_close                           # それを閉じる
    end
    window_b do
      piece_move_o("33", "34", "☖3四歩")                # bは時間切れになったがそれを無視して指した
      assert_white_read_sec(@INITIAL_SEC)               # すると秒読みが復活した
      assert_clock_active_black                         # 時計も相手に切り替わった
    end
    window_a do
      assert_clock_active_black                         # a側もaがアクティブになった
      assert_white_read_sec(@INITIAL_SEC)               # bの秒読みが復活している
      piece_move_o("77", "76", "☗7六歩")                # aは3手目を指した
      assert_clock_active_white                         # bに時計が切り替わった
    end
    window_b do
      assert_clock_active_white                         # b側もb側にの時計に切り替わった
      sleep(@INITIAL_SEC)                               # bは再び時間切れになるまで待った
      assert_text("時間切れで☗の勝ち")                  # 2度目のダイアログが出た
      cc_timeout_modal_close                            # いったん閉じないと assert_white_read_sec が失敗するため
      assert_white_read_sec(0)                          # また0時間切れになった
    end
    window_a do
      assert_text("時間切れで☗の勝ち")                  # a側でもダイアログが出た
    end
  end
end
