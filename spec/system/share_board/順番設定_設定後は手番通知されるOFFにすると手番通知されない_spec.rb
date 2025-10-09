require "#{__dir__}/shared_methods"

RSpec.describe "順番設定_設定後は手番通知されるOFFにすると手番通知されない", type: :system, share_board_spec: true do
  def case1(user_name)
    room_setup2(user_name, :room_restore_key => :skip)
  end

  it "works" do
    window_a { case1(:alice) }
    window_b { case1(:bob)   }
    window_a do
      order_set_on                            # 順番設定ON
      piece_move_o("77", "76", "☗7六歩")      # aliceが指す
    end
    window_b do
      assert_var(:tn_counter, 1) # aliceが指し終わったのでaliceに通知
      piece_move_o("33", "34", "☖3四歩")      # bobが指す
    end
    window_a do
      assert_var(:tn_counter, 1) # bobが指し終わったのでaliceに通知
      order_set_off                           # 順番設定OFF
      piece_move_o("27", "26", "☗2六歩")      # aliceが指す
    end
    window_b do
      assert_var(:tn_counter, 1) # 順番設定OFFなので通知されずカウンタは進んでいない
    end
  end
end
