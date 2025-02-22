require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      room_setup("test_room", "alice")               # aliceが部屋を作る
    end
    b_block do
      room_setup("test_room", "bob")                 # bobも同じ入退室
    end
    b_block do
      order_set_on                                 # 順番設定ON
      clock_start                                  # 対局時計 PLAY
    end
    a_block do
      assert_text("aliceから開始をaliceだけに通知") # 最初はaliceさんから開始
    end
    b_block do
      assert_text("aliceさんから開始してください") # bobさんの方でも誰から開始するかが示された
    end
  end
end
