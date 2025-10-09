require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    window_a do
      room_setup_by_user(:alice) # aliceが部屋を作る
    end
    window_b do
      room_setup_by_user(:bob)   # bobも同じ入退室
      assert_member_exist(:alice)   # alice がいる
      assert_member_exist(:bob)     # bob もいる
    end
    window_a do
      assert_member_exist(:alice)   # alice の部屋にも alice と
      assert_member_exist(:bob)     # bob がいる
      gate_leave_handle                     # 退室
    end
    window_b do
      assert_member_missing(:alice) # bob 側の alice が即座に消えた
      assert_member_exist(:bob)     # bob は、おる
    end
  end
end
