require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a do
      # alice が先手で bob を後手とする
      visit_room({
          :user_name            => :alice,
          :fixed_member   => "alice,bob",
          :fixed_order    => "alice,bob",
          :fixed_order_state    => "to_o2_state",
        })
      assert_viewpoint(:black)
    end

    window_b do
      room_setup_by_user(:bob) # bob はいったん接続切れのあと再度入退室
      assert_viewpoint(:white)       # そのとき order_copy_from_bc で後手なので盤を反転している
    end
  end
end
