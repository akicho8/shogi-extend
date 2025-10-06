require "#{__dir__}/../shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  before do
    @room_key = SecureRandom.hex
  end

  def case1(user_name)
    visit_room({
        :room_key           => @room_key,
        :user_name          => user_name,
        :fixed_member_names => "alice,bob",
        :fixed_order_names  => "alice,bob",
        :autoexec           => "cc_auto_start",
      })
  end

  it "works" do
    a_block { case1("alice") }
    b_block { case1("bob") }
    b_block do
      give_up_run                        # bob は手番ではないがヘッダーの「投了」ボタンを押す
      assert_var("alice.win_count", 1) # bob が負けたので alice にバッジ付与している (member_match_record_broadcast, xprofile_share_broadcasted)
      assert_var("bob.win_count", 0)
    end
    a_block do
      assert_var("alice.win_count", 1) # alice から見ても同じ
      assert_var("bob.win_count", 0)
    end

    # 後日──

    a_block { case1("alice") }
    b_block { case1("bob") }
    a_block do
      assert_var("alice.win_count", 1) # バッジは復元されている (xprofile_load)
      assert_var("bob.win_count", 0)
    end
    b_block do
      assert_var("alice.win_count", 1) # alice からバッジ数が配布される (xprofile_share)
      assert_var("bob.win_count", 0)
    end
  end
end
