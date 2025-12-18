require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  before do
    @KILL_SEC = 5
  end

  it "works" do
    window_a { room_setup_by_user(:a, ALIVE_NOTIFY_INTERVAL: 1, KILL_SEC: @KILL_SEC) } # 5秒以上通知がないと死んだと見なす
    window_b { room_setup_by_user(:b, ALIVE_NOTIFY_INTERVAL: 60)                     } # bさんは入った直後と60秒後に通知する

    # すると a さんには b さんから KILL_SEC 秒後に通知がないので b さんを死んだものとする

    window_a do
      assert_text("bさんの霊圧が消えました", wait: @KILL_SEC * 2) # 余裕をもって2倍待つ
      assert_action_index(0, "b", "💀")                           # 主語が b である (重要)
    end
  end
end
