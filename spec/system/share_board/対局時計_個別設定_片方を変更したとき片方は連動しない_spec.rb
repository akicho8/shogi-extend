require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      room_setup("my_room", "alice")
      clock_open
      clock_box_set(1, 2, 3, 4)                     # aliceが時計を設定する
      find(".cc_unique_mode_set_handle").click      # 個別設定を押す
      cc_in(2) do
        clock_box_values_eq [1, 2, 3, 4]            # ▲側が△にコピーされている
        clock_box_set(5, 6, 7, 8)                   # △側を更新する
      end
      cc_in(1) do
        clock_box_values_eq [1, 2, 3, 4]            # ▲側は変更されていない (内容は同じだが別のメモリを指している)
      end
    end
    b_block do
      room_setup("my_room", "bob")
      assert_text "cc_params:[[1,2,3,4],[5,6,7,8]]" # 個別設定がbobにも伝わっている
    end
  end
end
