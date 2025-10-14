require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  before do
    @initial_read_sec       = 5 # 5秒切れ負け
    @CC_TIMEOUT_BC_DELAY    = 0 # 当事者はN秒待って他者たちに時間切れをBCする (ネット遅延のシミュレート)
    @CC_TIMEOUT_JUDGE_DELAY = 3 # 通知が来なくてもN秒後に自力で時間切れモーダルを表示
  end

  def case1(user_name)
    visit_room({
        "user_name"              => user_name,
        "fixed_member"           => "alice,bob",
        "fixed_order"            => "alice,bob",
        "RS_RESEND_DELAY"        => -1,
        "CC_TIMEOUT_JUDGE_DELAY" => @CC_TIMEOUT_JUDGE_DELAY,
        "CC_TIMEOUT_BC_DELAY"    => @CC_TIMEOUT_BC_DELAY,
        **clock_box_params([0, @initial_read_sec, 0, 0]),
      })
  end

  it "当事者側(自分は即座に起動してBC)" do
    window_a { case1(:alice) }
    window_b { case1(:bob)   }
    window_a { clock_start    }
    window_a do
      sleep(@initial_read_sec)                          # alice 側が切れ負けるのでそれまで待つ
      nil                                               # CC_TIMEOUT_BC_DELAY は 0 なので通知する
      assert_timeout_modal_exist                        # モーダルはもう出ている (これは通知を受けてではなく自分用にすぐ出している)
      cc_timeout_modal_close                               # assert_text のためにモーダルを閉じる
      assert_text("当事者は自分で起動してBC")           # alice が自分用に自分で発動したのがわかる
      assert_text("BC受信時にはすでにモーダル起動済み") # ここがわかりにくいが自分でモーダル起動していたので自分のBCは意味がなかったとわかる
    end
    window_b { assert_timeout_modal_exist }              # bob 側には alice が通知したことでモーダルが出ている
  end

  it "他者側(予約するがBCの方が速いのでキャンセルされる)" do
    @CC_TIMEOUT_BC_DELAY   = 2 # alice 側
    @CC_TIMEOUT_JUDGE_DELAY = 4 # bob   側
    window_a { case1(:alice) }
    window_b { case1(:bob)   }
    window_a { clock_start    }
    window_b do
      sleep(@initial_read_sec)                      # alice 側が切れ負けるのでそれまで待つ
      nil                                           # bob は 4 秒後に「時間切れでbobの勝ち」モーダルを表示予約する
      sleep(@CC_TIMEOUT_BC_DELAY)                   # alice 側から 2 秒後に
      assert_timeout_modal_exist                    # 通知が来て、その予約はキャンセルされて「時間切れでbobの勝ち」モーダルを表示する
      cc_timeout_modal_close                           # assert_text のためにモーダルを閉じる
      assert_text("BC受信によってモーダル起動開始") # alice からの通知によってモーダル起動したことがわかる
      assert_text("時間切れ予約キャンセル")         # bob の予約がキャンセルされたのがわかる
    end
    window_a { assert_timeout_modal_exist }
  end

  it "他者側(予約待ち0なので他者側で即発動)" do
    @CC_TIMEOUT_BC_DELAY   = 3 # alice 側
    @CC_TIMEOUT_JUDGE_DELAY = 0 # bob   側
    window_a { case1(:alice) }
    window_b { case1(:bob)   }
    window_a { clock_start    }
    window_b do
      sleep(@initial_read_sec)         # alice 側が切れ負けるのでそれまで待つ
      assert_timeout_modal_exist       # bob 側が CC_TIMEOUT_JUDGE_DELAY (0) なので即座にモーダル(bobの勝ち)が表示される
      sleep(@CC_TIMEOUT_BC_DELAY * 2)  # その直後に @CC_TIMEOUT_BC_DELAY (3) 秒後に alice から通知がくる (余裕をもって2倍待つ)
      cc_timeout_modal_close           # assert_text が動くようにいったんモーダルを除去する
      assert_text("BC受信時にはすでにモーダル起動済み")
    end
    window_a { assert_timeout_modal_exist }
  end
end
