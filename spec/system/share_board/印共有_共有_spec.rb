require "#{__dir__}/shared_methods"

RSpec.describe "印共有_共有", type: :system, share_board_spec: true do
  def case1(user_name, think_mark_receive_scope_key)
    visit_app({
        :room_key                     => :test_room,
        :user_name                    => user_name,
        :fixed_member_names           => "a,b,c",
        :fixed_order_names            => "a,b",
        :handle_name_validate         => "false",
        :fixed_order_state            => "to_o2_state",
        :think_mark_mode_p            => true,
        :think_mark_receive_scope_key => think_mark_receive_scope_key,
      })
  end

  def case2(think_mark_receive_scope_key)
    a_block { case1("a", think_mark_receive_scope_key) }
    b_block { case1("b", think_mark_receive_scope_key) }
    c_block { case1("c", think_mark_receive_scope_key) }
  end

  it "tmrs_watcher_only: 観戦者のみ" do
    case2("tmrs_watcher_only")
    a_block { place_click("76") }
    a_block { assert_selector(".ThinkMark") }     # 対局者a → 対局者a ○
    b_block { assert_no_selector(".ThinkMark") }  # 対局者a → 対局者b ×
    c_block { assert_selector(".ThinkMark") }     # 対局者a → 観戦者c ○

    a_block { p has_selector?(".ThinkMark") }     # 対局者a → 対局者a ○
    b_block { p has_selector?(".ThinkMark") }     # 対局者a → 対局者b ×
    c_block { p has_selector?(".ThinkMark") }     # 対局者a → 観戦者c ○

  end

  it "tmrs_watcher_with_opponent: 対局者を含む" do
    case2("tmrs_watcher_with_opponent")
    a_block { place_click("76") }
    a_block { assert_selector(".ThinkMark") }     # 対局者a → 対局者a ○
    b_block { assert_selector(".ThinkMark") }     # 対局者a → 対局者b ○
    c_block { assert_selector(".ThinkMark") }     # 対局者a → 観戦者c ○
  end

  it "tmrs_everyone: 全員" do
    case2("tmrs_everyone")
    c_block { place_click("76") }
    a_block { assert_selector(".ThinkMark") }     # 観戦者c → 対局者a ○
    b_block { assert_selector(".ThinkMark") }     # 観戦者c → 対局者b ○
    c_block { assert_selector(".ThinkMark") }     # 観戦者c → 観戦者c ○
  end
end
