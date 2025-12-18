require "#{__dir__}/sb_support_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a do
      room_setup_by_user(:a)          # aが部屋を作る
    end
    window_b do
      room_setup_by_user(:b)            # bも同じ入退室
    end
    window_a do
      order_set_on                              # 順番設定ON
      assert_viewpoint(:black)
    end
    window_b do
      assert_viewpoint(:white)                  # 順番設定を反映したタイミングで b は後手なので盤面を反転する
    end
  end
end
