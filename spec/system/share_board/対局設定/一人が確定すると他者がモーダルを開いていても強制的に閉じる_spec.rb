require "#{__dir__}/../shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a { room_setup_by_user(:a) }
    window_b { room_setup_by_user(:b) }
    window_b do
      sidebar_open
      order_modal_open_handle   # b が「対局設定」を開いている状態だけど
    end
    window_a { order_set_on }   # a が「対局設定」を確定させたため
    window_b { assert_no_selector(".OrderModal") } # b の対局設定が消えている
    window_a { assert_no_selector(".OrderModal") } # もちろん a の方も消えている
  end
end
