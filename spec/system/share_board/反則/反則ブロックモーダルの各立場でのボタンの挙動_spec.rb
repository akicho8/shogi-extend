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
      window_a { assert_text "本来であればこの時点でaさんの負けです" }

      # 個別
      window_a { assert_text "潔く投了しますか？" }
      window_b { assert_text "bさんは反則を取り消すことができます。どうしますか？" }
      window_c { assert_text "cさんは反則していませんが仲間なので投了できます。潔く投了しますか？" }
    end

    it "当事者の立場" do
      case2
      window_a do
        find(".illegal_block_modal_submit_handle_no").click
        assert_text "自分でなかったことにはできません"

        find(".illegal_block_modal_submit_handle_yes").click
        assert_action "a", "投了"
        assert_clock(:stop)
      end
    end

    it "対戦者の立場" do
      case2
      window_b do
        find(".illegal_block_modal_submit_handle_yes").click
        assert_text "bさんは対戦相手なので投了できません"

        find(".illegal_block_modal_submit_handle_no").click
        assert_text "bさんが反則をなかったことにしました"
        assert_clock(:play)
      end
    end

    it "仲間の立場" do
      case2
      window_c do
        find(".illegal_block_modal_submit_handle_no").click
        assert_text "cさんは仲間なのでなかったことにはできません"

        find(".illegal_block_modal_submit_handle_yes").click
        assert_action "a", "投了"
        assert_clock(:stop)
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
        assert_text "cさんは観戦者なので何もできません"

        find(".illegal_block_modal_submit_handle_no").click
        assert_text "cさんは観戦者なので触らんといてください"

        find(".illegal_block_modal_submit_handle_yes").click
        assert_text "cさんは観戦者なので触らんといてください"
      end
    end
  end
end
