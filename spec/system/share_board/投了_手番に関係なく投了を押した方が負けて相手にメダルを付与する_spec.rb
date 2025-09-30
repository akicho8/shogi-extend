require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(user_name)
    visit_app({
        :room_key                   => :test_room,
        :user_name                   => user_name,
        :fixed_member_names          => "alice,bob",
        :fixed_order_names           => "alice,bob",
        "clock_box.initial_main_min" => 60,
        :autoexec => "cc_auto_start",
      })
  end

  it "works" do
    a_block do
      case1("alice")
    end
    b_block do
      case1("bob")
      give_up_run                             # bob は手番ではないがヘッダーの「投了」ボタンを押す
      assert_member_has_text("alice", "⭐") # bob が負けたので alice にバッジ付与している
    end
    a_block do
      assert_member_has_text("alice", "⭐") # alice から見ても同じ
    end
  end
end
