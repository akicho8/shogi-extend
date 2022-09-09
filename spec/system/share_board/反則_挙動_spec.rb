require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def foul_behavior_key(foul_behavior_key)
    sfen = "position sfen 8+r/8B/7PK/9/9/9/9/9/9 b P 1"
    visit_app(body: sfen, foul_behavior_key: foul_behavior_key)
    find(".Membership.is_black .piece_P").click # 持駒の歩を持つ
    find(".place_2_2").click                    # 22打
  end

  it "一般用「できる・注意あり(全体へ)」" do
    foul_behavior_key("is_foul_behavior_auto")
    assert_selector(".place_2_2.current")
    assert_selector(".ShareBoardActionLog .flex_item", text: "二歩", exact_text: true)
  end

  it "初心者用「できない・注意あり(本人へ)」" do
    foul_behavior_key("is_foul_behavior_newbie")
    assert_no_selector(".place_2_2.current")
    assert_system_variable(:latest_foul_name, "二歩")
    assert_no_selector(".ShareBoardActionLog .flex_item", text: "二歩", exact_text: true)
  end

  it "玄人用「できる・注意なし」" do
    foul_behavior_key("is_foul_behavior_throw")
    assert_selector(".place_2_2.current")
    assert_no_selector(".ShareBoardActionLog .flex_item", text: "二歩", exact_text: true)
  end
end
