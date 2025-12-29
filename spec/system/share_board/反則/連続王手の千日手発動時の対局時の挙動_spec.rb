require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  describe "対局中" do
    def case1(foul_mode_key)
      visit_room({
          :body                  => SfenInfo.fetch("連続王手の千日手確認用").sfen,
          :foul_mode_key         => foul_mode_key,
          :user_name             => "a",
          :FIXED_MEMBER          => "a",
          :FIXED_ORDER           => "a",
          :room_after_create     => :cc_auto_start_10m,
          :self_vs_self_enable_p => true,
        })
    end

    it "「反則したら負け」のときは即負ける" do
      case1("lose")
      perpetual_check_trigger
      assert_selector(".IllegalLoseModal")
    end

    it "「反則しても待ったできる」のときは本当なら IllegalTakebackModal が出るべきだが都合上警告だけになっている" do
      case1("takeback")
      perpetual_check_trigger
      assert_no_selector(".IllegalTakebackModal") # 出るべきだが出ていない
      assert_text "本来であれば「連続王手の千日手」でaさんの反則負けです"
      assert_text "次から指し手を変えてください"
    end
  end
end
