require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(user_name)
    visit_app({
        :room_key                   => :test_room,
        :user_name                   => user_name,
        :fixed_member_names          => "alice,bob",
        :fixed_order_names           => "alice,bob",
        "clock_box.initial_main_min" => 60,
        :clock_auto_start       => true,
        :acquire_badge_count         => 1,
      })
  end

  it "works" do
    a_block do
      case1("alice")
    end
    b_block do
      case1("bob")
    end
    a_block do
      assert_member_has_text("alice", "⭐")
      assert_member_has_text("bob", "⭐")
    end
    b_block do
      assert_member_has_text("alice", "⭐")
      assert_member_has_text("bob", "⭐")
    end
  end
end
