require "#{__dir__}/shared_methods"

RSpec.describe "印共有_共有スコープ", type: :system, share_board_spec: true do
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

  describe "対局者が操作した場合" do
    it "tmrs_watcher_only: 観戦者のみ" do
      case2("tmrs_watcher_only")
      a_block { assert_click_then_mark }
      assert_abc_marks "oxo" # a の印は観戦者cだけが見れる
    end

    it "tmrs_watcher_with_opponent: 対局者を含む" do
      case2("tmrs_watcher_with_opponent")
      a_block { assert_click_then_mark }
      assert_abc_marks "ooo" # a の印が対局者bにも見えている
    end

    it "tmrs_everyone: 対局者を含む" do
      case2("tmrs_everyone")
      a_block { assert_click_then_mark }
      assert_abc_marks "ooo" # 受信制限がないので全員見えている
    end
  end

  describe "観戦者が操作した場合" do
    it "tmrs_watcher_only: 観戦者のみ" do
      case2("tmrs_watcher_only")
      c_block { assert_click_then_mark }
      assert_abc_marks "xxo"    # 観戦者cが印をつけても対局者は見れない
    end

    it "tmrs_watcher_with_opponent: 対局者を含む" do
      case2("tmrs_watcher_with_opponent")
      c_block { assert_click_then_mark }
      assert_abc_marks "xxo"    # 観戦者cが印をつけても対局者は見れない
    end

    it "tmrs_everyone: 対局者を含む" do
      case2("tmrs_everyone")
      c_block { assert_click_then_mark }
      assert_abc_marks "ooo"    # 制限がないため観戦者cが対局者にまで届いている
    end
  end

  ################################################################################

  def assert_click_then_mark
    place_click("76")
    assert_selector(".ThinkMark")
  end

  def assert_abc_marks(expected, message)
    actual = [
      a_block { has_selector?(".ThinkMark") } ? "o" : "x",
      b_block { has_selector?(".ThinkMark") } ? "o" : "x",
      c_block { has_selector?(".ThinkMark") } ? "o" : "x",
    ].join

    assert(message) { actual == expected }
  end
end
