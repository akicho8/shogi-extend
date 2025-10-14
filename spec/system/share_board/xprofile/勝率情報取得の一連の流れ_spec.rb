require "#{__dir__}/../shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  before do
    @room_key = SecureRandom.hex
  end

  def case1(user_name)
    visit_room({
        :room_key           => @room_key,
        :user_name          => user_name,
        :fixed_member => "alice,bob",
        :fixed_order  => "alice,bob",
        :room_create_after_action => :cc_auto_start,
      })
  end

  it "works" do
    window_a { case1(:alice) }
    window_b { case1(:bob) }
    window_b do
      give_up_run                        # bob は手番ではないがヘッダーの「投了」ボタンを押す
      assert_var("alice.win_count", 1) # bob が負けたので alice にバッジ付与している (member_match_record_broadcast, xprofile_share_broadcasted)
      assert_var("bob.win_count", 0)
    end
    window_a do
      assert_var("alice.win_count", 1) # alice から見ても同じ
      assert_var("bob.win_count", 0)
    end

    # 後日──

    window_a { case1(:alice) }
    window_b { case1(:bob) }
    window_a do
      assert_var("alice.win_count", 1) # バッジは復元されている (xprofile_load)
      assert_var("bob.win_count", 0)
    end
    window_b do
      assert_var("alice.win_count", 1) # alice からバッジ数が配布される (xprofile_share)
      assert_var("bob.win_count", 0)
    end
  end
end
