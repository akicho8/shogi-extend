require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  describe "対局中" do
    def case1(user_name, foul_mode_key)
      visit_room({
          :body              => sfen,
          :foul_mode_key     => foul_mode_key,
          :user_name         => user_name,
          :FIXED_MEMBER      => "a,b",
          :FIXED_ORDER       => "a,b",
          :room_after_create => :cc_auto_start_10m,
        })
    end

    it "lose: したら負け" do
      window_a { case1(:a, :lose) }
      window_b { case1(:b, :lose) }
      window_a { double_pawn! }
      window_a do
        notice_exist
        lose_modal_exist
        block_modal_none
        action_log_exist
      end
      window_b do
        notice_exist
        lose_modal_exist
        block_modal_none
        action_log_exist
      end
    end

    it "block: ブロック" do
      window_a { case1(:a, :block) }
      window_b { case1(:b, :block) }
      window_a { double_pawn! }
      window_a do
        notice_exist
        lose_modal_none
        block_modal_exist
        action_log_exist
      end
      window_b do
        notice_exist
        lose_modal_none
        block_modal_exist
        action_log_exist
      end
    end

    it "ignore: 関与しない" do
      window_a { case1(:a, :ignore) }
      window_b { case1(:b, :ignore) }
      window_a { double_pawn! }
      window_a do
        notice_none
        lose_modal_none
        block_modal_none
        action_log_none
      end
      window_b do
        notice_none
        lose_modal_none
        block_modal_none
        action_log_none
      end
    end
  end

  describe "感想戦中" do
    def case1(user_name, foul_mode_key)
      visit_room({
          :body          => sfen,
          :foul_mode_key => foul_mode_key,
          :user_name     => user_name,
          :FIXED_MEMBER  => "a,b",
        })
    end

    it "「反則したら負け」モードでも感想戦中は「反則ブロック」相当になっている (ただしモーダルは出さない)" do
      window_a { case1(:a, :lose) }
      window_b { case1(:b, :lose) }
      window_a { double_pawn! }
      window_a do
        notice_exist
        lose_modal_none
        block_modal_none
        action_log_exist
      end
      window_b do
        notice_exist
        lose_modal_none
        block_modal_none
        action_log_exist
      end
    end
  end
end
