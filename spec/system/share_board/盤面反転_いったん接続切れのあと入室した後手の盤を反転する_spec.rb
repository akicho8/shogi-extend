require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a do
      visit_room({
          :user_name    => :a,
          :FIXED_MEMBER => "a,b",
          :FIXED_ORDER  => "a,b",
        })
      assert_viewpoint(:black)
    end

    window_b do
      room_setup_by_user(:b)    # b はいったん接続切れのあと再度入退室
      assert_viewpoint(:white)  # そのとき order_copy_from_bc で後手なので盤を反転している
    end
  end
end
