require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def sfen
    "position sfen 8+r/8B/7PK/9/9/9/9/9/9 b P 1"
  end

  def double_pawn_warning
    assert_no_selector(".place_2_2.current")
    assert_var(:latest_illegal_name, "二歩")
    assert_no_selector(".SbActionLog .flex_item", text: "二歩", exact_text: true)
  end

  context "検討中" do
    def foul_mode_key(foul_mode_key)
      visit_app(:body => sfen, :foul_mode_key => foul_mode_key)
      find(".Membership.is_black .piece_P").click # 持駒の歩を持つ
      find(".place_2_2").click                    # 22打
    end

    it "本来モーダルが出るはずだが順番が有効になっていないためモーダルはでない(block相当になっている)" do
      foul_mode_key("lose")
      double_pawn_warning
    end
  end

  context "対局中" do
    def foul_mode_key(foul_mode_key)
      visit_room({
          :body                 => sfen,
          :foul_mode_key        => foul_mode_key,
          :user_name            => "1",
          :fixed_member_names   => "1,2",
          :fixed_order_names    => "1,2",
          :fixed_order_state    => "to_o2_state",
          :handle_name_validate => false,
        })
      find(".Membership.is_black .piece_P").click # 持駒の歩を持つ
      find(".place_2_2").click                    # 22打
    end

    it "一般用「できる・注意あり(全体へ)」" do
      foul_mode_key("lose")
      assert_selector(".place_2_2.current")

      assert_selector(".IllegalModal", text: "二歩で☖の勝ち")
      find(".close_handle").click

      assert_selector(".SbActionLog .flex_item", text: "二歩", exact_text: true)
    end

    it "初心者用「できない・注意あり(本人へ)」" do
      foul_mode_key("block")
      double_pawn_warning
    end

    it "玄人用「できる・注意なし」" do
      foul_mode_key("ignore")
      assert_selector(".place_2_2.current")
      assert_no_selector(".SbActionLog .flex_item", text: "二歩", exact_text: true)
    end
  end
end
