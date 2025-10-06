require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      # alice が先手で bob を後手とする
      visit_room({
          :room_key            => :test_room,
          :user_name            => "alice",
          :fixed_member_names   => "alice,bob",
          :fixed_order_names    => "alice,bob",
          :fixed_order_state    => "to_o2_state",
        })
      assert_viewpoint(:black)
    end

    b_block do
      room_setup("test_room", "bob") # bob はいったん接続切れのあと再度入退室
      assert_viewpoint(:white)       # そのとき order_copy_from_bc で後手なので盤を反転している
    end
  end
end
