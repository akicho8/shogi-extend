require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  describe "検討中" do
    it "反則モードに関係なく履歴に出すだけ" do
      visit_app
      perpetual_trigger
      assert_action_text("千日手")              # 履歴に「千日手」のテキストが出ている
      assert_no_selector(".modal")              # モーダルはでない
    end
  end

  describe "対局中" do
    def case1(foul_mode_key)
      visit_room({
          :foul_mode_key         => foul_mode_key,
          :user_name             => "a",
          :FIXED_MEMBER          => "a",
          :FIXED_ORDER           => "a",
          :self_vs_self_enable_p => true,
          :room_after_create     => :cc_auto_start_10m,
          :RESEND_FEATURE        => false,
        })
      perpetual_trigger
    end

    def assert_message
      assert_action_text("千日手")
      assert_text("本来であれば「千日手」で引き分けです")
      assert_text("どちらかが指し手を変えてください")
    end

    it "したら負け" do
      case1(:lose)
      assert_message
    end

    it "しても待ったできる" do
      case1(:takeback)
      assert_message
    end

    it "関与しない" do
      case1(:ignore)
      assert_no_action_text("千日手")
    end
  end
end
