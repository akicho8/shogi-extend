require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    window_a do
      room_setup2(:alice, auto_room_url_copy_modal_p: true)
      assert_member_exist(:alice)
      assert_text "部屋のリンクをコピーしますか？", wait: 30
    end
    window_b do
      room_setup2(:bob, auto_room_url_copy_modal_p: true)
      assert_member_exist(:bob)
      assert_no_text "部屋のリンクをコピーしますか？", wait: 30 # 2人なので表示しない
    end
  end
end
