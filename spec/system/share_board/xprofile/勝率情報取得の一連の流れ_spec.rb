require "#{__dir__}/../shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  before do
    @room_key = SecureRandom.hex
  end

  def case1(user_name)
    visit_room({
        :room_key           => @room_key,
        :user_name          => user_name,
        :FIXED_MEMBER => "a,b",
        :FIXED_ORDER  => "a,b",
        :room_after_create => :cc_auto_start_10m,
      })
  end

  it "works" do
    window_a { case1(:a) }
    window_b { case1(:b) }
    window_b do
      resign_run                        # b は手番ではないがヘッダーの「投了」ボタンを押す
      assert_var("a.win_count", 1) # b が負けたので a にバッジ付与している (member_match_record_broadcast, xprofile_share_broadcasted)
      assert_var("b.win_count", 0)
    end
    window_a do
      assert_var("a.win_count", 1) # a から見ても同じ
      assert_var("b.win_count", 0)
    end

    # 後日──

    window_a { case1(:a) }
    window_b { case1(:b) }
    window_a do
      assert_var("a.win_count", 1) # バッジは復元されている (xprofile_load)
      assert_var("b.win_count", 0)
    end
    window_b do
      assert_var("a.win_count", 1) # a からバッジ数が配布される (xprofile_share)
      assert_var("b.win_count", 0)
    end
  end
end
