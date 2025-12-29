require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do

  describe "当事者と仲間と対戦者" do
    def case1(user_name)
      visit_room({
          :body              => sfen,
          :foul_mode_key => "takeback",
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

      window_a { takeback_modal_exist }
      window_b { takeback_modal_exist }
      window_c { takeback_modal_exist }

      # 共通文言
      window_a { assert_text "本来であればaさんの反則負けです" }
      window_a { assert_text "潔く投了しますか？" }

      # 個別
      window_b { assert_text "bさんは「待った」で反則をなかったことにできます" }
      window_c { assert_text "cさんは仲間なので待ったできます" }
    end

    describe "当事者の立場" do
      it "待ったする" do
        case2
        window_a { find(".illegal_takeback_modal_submit_handle_takeback").click }
        fn = -> {
          assert_text "aさんが自分の反則をなかったことにしました"
          assert_takeback_success
        }
        window_a { fn.call }
        window_b { fn.call }
        window_c { fn.call }
      end

      it "投了する" do
        case2
        window_a { find(".illegal_takeback_modal_submit_handle_resign").click }
        window_a { assert_resign_success }
        window_b { assert_resign_success }
        window_c { assert_resign_success }
      end
    end

    describe "対戦者の立場" do
      it "待ったする" do
        case2
        window_b { find(".illegal_takeback_modal_submit_handle_takeback").click }
        fn = -> {
          assert_text "bさんがお情けで反則をなかったことにしました"
          assert_takeback_success
        }
        window_a { fn.call }
        window_b { fn.call }
        window_c { fn.call }
      end

      it "投了する" do
        case2
        window_b do
          find(".illegal_takeback_modal_submit_handle_resign").click
          assert_resign_ng
          assert_text "bさんは対戦相手なので投了できません"
        end
      end
    end

    describe "仲間の立場" do
      it "待ったする" do
        case2
        window_c { find(".illegal_takeback_modal_submit_handle_takeback").click }
        fn = -> {
          assert_text "cさんが仲間の反則をなかったことにしました"
          assert_takeback_success
        }
        window_a { fn.call }
        window_b { fn.call }
        window_c { fn.call }
      end

      it "投了する" do
        case2
        window_c { find(".illegal_takeback_modal_submit_handle_resign").click }
        window_a { assert_resign_success }
        window_b { assert_resign_success }
        window_c { assert_resign_success }
      end
    end
  end

  describe "観戦者の立場" do
    def case1(user_name)
      visit_room({
          :body              => sfen,
          :foul_mode_key     => "takeback",
          :user_name         => user_name,
          :FIXED_MEMBER      => "a,b,c",
          :FIXED_ORDER       => "a,b",
          :room_after_create => :cc_auto_start_10m,
        })
    end

    def case2
      window_a { case1(:a) }
      window_b { case1(:b) }
      window_c { case1(:c) }
      window_a { double_pawn! }
    end

    it "投了する" do
      case2
      window_c do
        assert_text "cさんは観戦者ですが「待った」で反則をなかったことにできます"

        find(".illegal_takeback_modal_submit_handle_resign").click
        assert_resign_ng
        assert_text "cさんは観戦者なので投了できません"
      end
    end

    it "待ったする" do
      case2
      window_c { find(".illegal_takeback_modal_submit_handle_takeback").click }
      fn = -> {
        assert_text "cさんが反則をなかったことにしました"
        assert_takeback_success
      }
      window_a { fn.call }
      window_b { fn.call }
      window_c { fn.call }
    end
  end
end
