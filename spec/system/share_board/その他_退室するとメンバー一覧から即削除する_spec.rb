require "#{__dir__}/sb_support_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a do
      room_setup_by_user(:a) # aが部屋を作る
    end
    window_b do
      room_setup_by_user(:b)   # bも同じ入退室
      assert_member_exist(:a)   # a がいる
      assert_member_exist(:b)     # b もいる
    end
    window_a do
      assert_member_exist(:a)   # a の部屋にも a と
      assert_member_exist(:b)     # b がいる
      gate_leave_handle                     # 退室
    end
    window_b do
      assert_member_missing(:a) # b 側の a が即座に消えた
      assert_member_exist(:b)     # b は、おる
    end
  end
end
