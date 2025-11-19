require "#{__dir__}/../shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a do
      room_setup_by_user(:a)               # aが部屋を作る
    end
    window_b do
      room_setup_by_user(:b)                 # bも同じ入退室
    end
    window_b do
      order_set_on                                 # 順番設定ON
      clock_start                                  # 対局時計 PLAY
    end
    window_a do
      assert_text("aから開始をaだけに通知") # 最初はaさんから開始
    end
    window_b do
      assert_text("aさんから開始しよう") # bさんの方でも誰から開始するかが示された
    end
  end
end
