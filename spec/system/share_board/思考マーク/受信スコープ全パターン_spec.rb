require "#{__dir__}/helper"

RSpec.describe "受信スコープ全パターン", type: :system, share_board_spec: true do
  def case1(user_name, think_mark_receive_scope_key)
    visit_app({
        :room_key                     => :test_room,
        :user_name                    => user_name,
        :fixed_member_names           => "a,b,c",
        :fixed_order_names            => "a,b",
        :handle_name_validate         => "false",
        :fixed_order_state            => :to_o2_state,
        :think_mark_mode_p            => true,
        :think_mark_receive_scope_key => think_mark_receive_scope_key,
      })
  end

  def case2(think_mark_receive_scope_key)
    a_block { case1("a", think_mark_receive_scope_key) }
    b_block { case1("b", think_mark_receive_scope_key) }
    c_block { case1("c", think_mark_receive_scope_key) }
  end

  describe "対局者の印" do
    it "観戦者のみ" do
      case2 :tmrs_watcher_only
      a_block { assert_click_then_mark } # 対局者aの印は
      assert_abc_marks "oxo"             # 観戦者cだけが見れる
    end

    it "対局者を含む" do
      case2 :tmrs_watcher_with_opponent
      a_block { assert_click_then_mark } # 対局者aの印が
      assert_abc_marks "ooo"             # 対戦相手のbにも見えている
    end

    it "全員" do
      case2 :tmrs_everyone
      a_block { assert_click_then_mark } # 対局者aの印は
      assert_abc_marks "ooo"             # 制限がないので全員見えている
    end
  end

  describe "観戦者の印" do
    it "観戦者のみ" do
      case2 :tmrs_watcher_only
      c_block { assert_click_then_mark } # 観戦者cの印は
      assert_abc_marks "xxo"             # 対局者は見れない
    end

    it "対局者を含む" do
      case2 :tmrs_watcher_with_opponent
      c_block { assert_click_then_mark } # 観戦者cの印は
      assert_abc_marks "xxo"             # 「観戦者から」の印のため対局者は見れない
    end

    it "全員" do
      case2 :tmrs_everyone
      c_block { assert_click_then_mark } # 観戦者cの印は
      assert_abc_marks "ooo"             # 制限がないので全員見えている
    end
  end
end
