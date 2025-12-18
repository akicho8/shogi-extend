require "#{__dir__}/sb_support_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "成功" do
    window_a { room_setup_by_user(:a) }
    window_b { room_setup_by_user(:b) }
    window_a do
      member_list_name_click(:b)
      find(:button, :class => "ping_handle").click
      assert_text("応答速度:")
    end
  end

  it "失敗" do
    @PING_OK_SEC = 3 # N秒以内ならPINGを成功とみなす
    @PONG_DELAY  = 5 # PONGするまでの秒数(デバッグ時には PING_OK_SEC 以上の値にする)
    window_a { visit_room(user_name: :a, PING_OK_SEC: @PING_OK_SEC) }
    window_b { visit_room(user_name: :b, PONG_DELAY: @PONG_DELAY) }
    window_a do
      member_list_name_click(:b)
      find(:button, :class => "ping_handle").click # 1回押し
      find(:button, :class => "ping_handle").click # 続けて押すと
      assert_text("応答待ち")
      assert_text("#{:b}さんの霊圧が消えました", wait: 30)
    end
  end
end
