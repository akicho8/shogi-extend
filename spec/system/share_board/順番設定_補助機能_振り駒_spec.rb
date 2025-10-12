require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(shakashaka_count)
    visit_room({
        :user_name            => "1",
        :fixed_member_names   => "1,2,3,4",
        :fixed_order_names    => "1,2,3,4",
        :fixed_order_state    => "to_o2_state",
        :furigoma_random_key  => "is_true",        # 毎回反転させる
        :shakashaka_count     => shakashaka_count, # 2回すると反転の反転で表に戻る(つまり「歩」が5枚)
      })
    os_modal_open
    os_switch_toggle
    find(".furigoma_handle").click
  end

  it "2回反転して元に戻る" do
    case1("2")
    assert_text("1さんが振り駒をした結果、歩が5枚で1さんの先手になりました")
    assert_order_team_one "13", "24"
    os_modal_force_submit
    os_modal_close
    assert_text("歩歩歩歩歩")
  end

  it "3回反転して逆になる" do
    case1("3")
    assert_text("1さんが振り駒をした結果、と金が5枚で2さんの先手になりました")
    assert_order_team_one "24", "13"
    os_modal_force_submit
    os_modal_close
    assert_text("ととととと")
  end
end
