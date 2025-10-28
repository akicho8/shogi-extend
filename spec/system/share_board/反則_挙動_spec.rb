require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def sfen
    "position sfen 8+r/8B/7PK/9/9/9/9/9/9 b P 1"
  end

  def double_pawn_warning
    assert_no_selector(".place_2_2.current")
    assert_var(:latest_illegal_name, "二歩")
    assert_no_selector(".SbActionLog .flex_item", text: "二歩", exact_text: true)
  end

  context "検討中" do
    def case1(foul_mode_key)
      visit_app(:body => sfen, :foul_mode_key => foul_mode_key, :room_after_create => :cc_auto_start_10m)
      stand_click(:black, :P)
      place_click("22")
    end

    it "本来モーダルが出るはずだが順番が有効になっていないためモーダルはでない(block相当になっている)" do
      case1(:lose)
      double_pawn_warning
    end
  end

  context "対局中" do
    def case1(foul_mode_key)
      visit_room({
          :body              => sfen,
          :foul_mode_key     => foul_mode_key,
          :user_name         => "a",
          :FIXED_MEMBER      => "a,b",
          :fixed_order       => "a,b",
          :room_after_create => :cc_auto_start_10m,
        })
      stand_click(:black, :P)
      place_click("22")
    end

    it "(1) 一般用「できる・注意あり(全体へ)」" do
      case1(:lose)
      assert_selector(".place_2_2.current")

      assert_selector(".IllegalModal", text: "二歩で☖の勝ち")
      find(".close_handle").click

      assert_selector(".SbActionLog .flex_item", text: "二歩", exact_text: true)
    end

    it "(2) 初心者用「できない・注意あり(本人へ)」" do
      case1(:block)
      double_pawn_warning
    end

    it "(3) 玄人用「できる・注意なし」" do
      case1(:ignore)
      assert_selector(".place_2_2.current")
      assert_no_selector(".SbActionLog .flex_item", text: "二歩", exact_text: true)
    end
  end
end
