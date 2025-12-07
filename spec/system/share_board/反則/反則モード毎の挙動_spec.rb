require "#{__dir__}/../shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def sfen
    "position sfen 8+r/8B/7PK/9/9/9/9/9/9 b P 1"
  end

  def double_pawn!
    stand_click(:black, :P)
    place_click("22")
  end

  def notice_exist
    assert_var(:latest_illegal_hv, "二歩")
  end

  def notice_none
    assert_var(:latest_illegal_hv, "")
  end

  def modal_exist
    assert_selector(".IllegalModal", text: "二歩で☖の勝ち")
  end

  def modal_none
    assert_no_selector(".IllegalModal")
  end

  def action_log_exist
    assert_selector(".SbActionLog .flex_item", text: "二歩", exact_text: true)
  end

  def action_log_none
    assert_no_selector(".SbActionLog .flex_item", text: "二歩", exact_text: true)
  end

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
        notice_none
        modal_exist
        action_log_exist
      end
      window_b do
        notice_none
        modal_exist
        action_log_exist
      end
    end

    it "block: ブロック" do
      window_a { case1(:a, :block) }
      window_b { case1(:b, :block) }
      window_a { double_pawn! }
      window_a do
        notice_exist
        modal_none
        action_log_exist
      end
      window_b do
        notice_exist
        modal_none
        action_log_exist
      end
    end

    it "ignore: 関与しない" do
      window_a { case1(:a, :ignore) }
      window_b { case1(:b, :ignore) }
      window_a { double_pawn! }
      window_a do
        notice_none
        modal_none
        action_log_none
      end
      window_b do
        notice_none
        modal_none
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

    it "「反則したら負け」モードでも感想戦中は「反則ブロック」相当になっている" do
      window_a { case1(:a, :lose) }
      window_b { case1(:b, :lose) }
      window_a { double_pawn! }
      window_a do
        notice_exist
        modal_none
        action_log_exist
      end
      window_b do
        notice_exist
        modal_none
        action_log_exist
      end
    end
  end
end
