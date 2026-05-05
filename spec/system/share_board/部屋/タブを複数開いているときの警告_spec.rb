require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a { room_setup_by_user(:a, ALIVE_NOTIFY_INTERVAL: 60) }
    window_b { room_setup_by_user(:a, ALIVE_NOTIFY_INTERVAL: 60) }
    window_a { assert_selector(".TabDupModal") }
    window_b { assert_selector(".TabDupModal") }
    window_a do
      find(".tab_dup_modal_close_handle").click
      assert_no_selector(".TabDupModal")
    end
  end
end
