require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a { room_setup_by_user(:a) }
    window_b { room_setup_by_user(:b) }
    window_a do
      order_set_on                             # 順番設定ON
      clock_start                              # 対局開始
      piece_move_o("77", "76", "☗7六歩")      # aが指す
    end
    window_b do
      assert_var(:tn_bell_count, 1) # aが指し終わったのでaに通知
      piece_move_o("33", "34", "☖3四歩")      # bが指す
    end
    window_a do
      assert_var(:tn_bell_count, 1) # bが指し終わったのでaに通知
      order_set_off                           # 順番設定OFF
      piece_move_o("27", "26", "☗2六歩")      # aが指す
    end
    window_b do
      assert_var(:tn_bell_count, 1) # 順番設定OFFなので通知されずカウンタは進んでいない
    end
  end
end
