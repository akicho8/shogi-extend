require "#{__dir__}/../shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a { room_setup_by_user(:a) }
    window_b { room_setup_by_user(:b) }
    window_c { room_setup_by_user(:c) }
    window_a do
      order_set_on              # a が 順番設定 ON
    end
    window_b do
      sidebar_open
      order_modal_open_handle   # b が「対局設定」を開く
    end
    window_c do
      sidebar_open
      cc_modal_open_handle      # c が「時計」を開く
    end
    window_a do
      clock_start               # a が対局開始
    end
    # 全員サイドバーと対局設定と時計が消えている
    window_a { assert_modal_all_close }
    window_b { assert_modal_all_close }
    window_c { assert_modal_all_close }
  end
end
