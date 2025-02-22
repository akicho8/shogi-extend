require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      room_setup("test_room", "alice")          # aliceが部屋を作る
    end
    b_block do
      room_setup("test_room", "bob")            # bobも同じ入退室
    end
    a_block do
      order_set_on                              # 順番設定ON
      assert_viewpoint(:black)
    end
    b_block do
      assert_viewpoint(:white)                  # 順番設定を反映したタイミングで bob は後手なので盤面を反転する
    end
  end
end
