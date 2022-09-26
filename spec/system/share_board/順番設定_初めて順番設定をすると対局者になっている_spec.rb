require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      room_setup("my_room", "alice")          # aliceが部屋を作る
    end
    b_block do
      room_setup("my_room", "bob")            # bobも同じ部屋に入る
    end
    a_block do
      order_set_on                            # 順番設定ON
      assert_system_variable("順序2", ["alice", "bob"].join)
      assert_system_variable("順序1", ["alice", "bob"].join)
    end
  end
end
