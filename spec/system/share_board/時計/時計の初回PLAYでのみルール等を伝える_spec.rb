require "#{__dir__}/../shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "3人で対局しているとき" do
    window_a { room_setup_by_user(:a) }
    window_b { room_setup_by_user(:b) }
    window_c { room_setup_by_user(:c) }
    window_b do
      order_set_on                                   # 対局設定ON
      clock_start                                    # 時計 PLAY
    end
    window_a do
      assert_text("aから開始をaだけに通知")          # 最初はaさんから開始
      assert_text("秒読み30秒 考慮時間1分")          # 最初に時間を伝える
      assert_text("手番は1手ごとに交代します")       # 3人以上で対局しているときだけ伝える
      assert_text("反則は即負けの紳士ルールです")
      assert_text("それではaさんから指してください")
    end
    window_b do
      assert_text("それではaさんから指してください") # bさんの方でも誰から開始するかが示された
    end
  end

  it "2人で対戦しているときに何手ごと交代かは伝えない" do
    window_a { room_setup_by_user(:a) }
    window_b { room_setup_by_user(:b) }
    window_b do
      order_set_on
      clock_start
    end
    window_a do
      assert_text("秒読み30秒 考慮時間1分")          # 最初に時間を伝える
      assert_no_text("手番は1手ごとに交代します")    # 2人以上で対局しているのでこの通知は無い
      assert_text("反則は即負けの紳士ルールです")
    end
  end
end
