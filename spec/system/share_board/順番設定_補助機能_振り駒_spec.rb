require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(shakashaka_count, piece_names, message)
    visit_app({
        :room_key            => :test_room,
        :user_name      => "1",
        :fixed_member_names   => "1,2,3,4",
        :fixed_order_names    => "1,2,3,4",
        :fixed_order_state    => "to_o2_state",
        :handle_name_validate => "false",
        :autoexec             => "os_modal_open_handle",
        :furigoma_random_key  => "is_true",        # 毎回反転させる
        :shakashaka_count     => shakashaka_count, # 2回すると反転の反転で表に戻る(つまり「歩」が5枚)
      })

    find(".furigoma_handle").click
    assert_text(piece_names)
    assert_text(message)
  end

  it "2回反転して元に戻る" do
    case1("2", "歩歩歩歩歩", "1さんが振り駒をした結果、歩が5枚で1さんの先手になりました")
    assert_order_team_one "13", "24"
  end

  it "3回反転して逆になる" do
    case1("3", "ととととと", "1さんが振り駒をした結果、と金が5枚で2さんの先手になりました")
    assert_order_team_one "24", "13"
  end
end
