require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(shakashaka_count)
    visit_room({
        :user_name           => "a",
        :FIXED_MEMBER        => "a,b,c,d",
        :FIXED_ORDER         => "a,b,c,d",
        :furigoma_random_key => "force_true",     # 毎回反転させる
        :shakashaka_count    => shakashaka_count, # 2回すると反転の反転で表に戻る(つまり「歩」が5枚)
      })
    os_modal_open
    os_switch_toggle
    find(".furigoma_handle").click
  end

  it "2回反転して元に戻る" do
    case1(2)
    assert_text("aさんが振り駒をした結果、歩が5枚でaさんの先手になりました")
    assert_order_team_one "ac", "bd"
    os_modal_force_submit
    os_modal_close
    assert_text("歩歩歩歩歩")
  end

  it "3回反転して逆になる" do
    case1(3)
    assert_text("aさんが振り駒をした結果、と金が5枚でbさんの先手になりました")
    assert_order_team_one "bd", "ac"
    os_modal_force_submit
    os_modal_close
    assert_text("ととととと")
  end
end
