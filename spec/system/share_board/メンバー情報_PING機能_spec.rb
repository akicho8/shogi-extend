require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "成功" do
    window_a do
      room_setup_by_user(:alice) # alice先輩が部屋を作る
    end
    window_b do
      room_setup_by_user(:bob) # bob後輩が同じ入退室
    end
    window_a do
      member_list_name_click(:bob)
      find(:button, :class => "ping_handle").click
      assert_text("bobさんの反応速度は")
    end
  end

  it "失敗" do
    @PING_OK_SEC = 3 # N秒以内ならPINGを成功とみなす
    @PONG_DELAY  = 5 # PONGするまでの秒数(デバッグ時には PING_OK_SEC 以上の値にする)
    window_a do
      visit_room(user_name: :alice, PING_OK_SEC: @PING_OK_SEC)
    end
    window_b do
      visit_room(user_name: :bob, PONG_DELAY: @PONG_DELAY)
    end
    window_a do
      member_list_name_click(:bob)
      find(:button, :class => "ping_handle").click # 1回押し
      find(:button, :class => "ping_handle").click # 続けて押すと
      assert_text("応答待ち")
      assert_text("bobさんの霊圧が消えました", wait: 30)
    end
  end
end
