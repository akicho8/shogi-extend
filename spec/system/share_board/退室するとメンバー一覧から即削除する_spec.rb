require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      room_setup("my_room", "alice") # aliceが部屋を作る
    end
    b_block do
      room_setup("my_room", "bob")   # bobも同じ部屋に入る
      assert_member_exist("alice")   # alice がいる
      assert_member_exist("bob")     # bob もいる
    end
    a_block do
      assert_member_exist("alice")   # alice の部屋にも alice と
      assert_member_exist("bob")     # bob がいる
      room_leave                     # 退室
    end
    b_block do
      assert_member_missing("alice") # bob 側の alice が即座に消えた
      assert_member_exist("bob")     # bob は、おる
    end
  end
end
