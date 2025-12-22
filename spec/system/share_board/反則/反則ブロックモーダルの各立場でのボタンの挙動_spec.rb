require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  describe "当事者と仲間と対戦者" do
    def case1(user_name)
      visit_room({
          :body              => sfen,
          :foul_mode_key     => "block",
          :user_name         => user_name,
          :FIXED_MEMBER      => "a,b,c",
          :FIXED_ORDER       => "a,b,c",
          :room_after_create => :cc_auto_start_10m,
        })
    end

    def case2
      window_a { case1(:a) }
      window_b { case1(:b) }
      window_c { case1(:c) }
      window_a { double_pawn! }
    end

    it "モーダルの内容" do
      case2

      window_a { assert_clock(:pause) }
      window_b { assert_clock(:pause) }
      window_c { assert_clock(:pause) }

      window_a { block_modal_exist }
      window_b { block_modal_exist }
      window_c { block_modal_exist }

      # 共通文言
      window_a { assert_text "本来であればこの時点でaさんの反則負けです" }
      window_a { assert_text "潔く投了しますか？" }

      # 個別
      window_b { assert_text "bさんは「待ったする」で反則をなかったことにできます" }
      window_c { assert_text "cさんは仲間なので投了も待ったもできます" }
    end

    describe "当事者の立場" do
      it "待ったする" do
        case2
        window_a do
          assert_block_success
          assert_text "aさんが自ら待ったして反則を揉み消しました"
        end
      end
      it "投了する" do
        case2
        window_a do
          assert_resign_success
        end
      end
    end

    it "対戦者の立場" do
      case2
      window_b do
        assert_resign_ng
        assert_text "bさんは対戦相手なので投了できません"

        assert_block_success
        assert_text "bさんがお情けで反則をなかったことにしました"
      end
    end

    describe "仲間の立場" do
      it "待ったする" do
        case2
        window_c do
          assert_block_success
          assert_text "cさんが待ったして仲間の反則を揉み消しました"
        end
      end

      it "投了する" do
        case2
        window_c do
          assert_resign_success
        end
      end
    end
  end

  describe "当事者と対戦者と観戦者" do
    def case1(user_name)
      visit_room({
          :body              => sfen,
          :foul_mode_key     => "block",
          :user_name         => user_name,
          :FIXED_MEMBER      => "a,b,c",
          :FIXED_ORDER       => "a,b",
          :room_after_create => :cc_auto_start_10m,
        })
    end

    it "観戦者の立場" do
      window_a { case1(:a) }
      window_b { case1(:b) }
      window_c { case1(:c) }
      window_a { double_pawn! }
      window_c do
        assert_text "cさんは観戦者ですが「待ったする」で反則をなかったことにできます"

        assert_resign_ng
        assert_text "cさんは観戦者なので投了できません"

        assert_block_success
        assert_text "cさんが反則をなかったことにしました"
      end
    end
  end
end
