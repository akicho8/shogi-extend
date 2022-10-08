require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      room_setup("my_room", "a", shuffle_first: false, handle_name_validate: false) # aliceが部屋を作る
    end
    b_block do
      room_setup("my_room", "b", shuffle_first: false, handle_name_validate: false)   # bobも同じ部屋に入る
    end
    a_block do
      order_set_on              # 順番設定ON
      assert_system_variable("順序2", "ab")
      assert_system_variable("順序1", "ab")
    end
  end
end
