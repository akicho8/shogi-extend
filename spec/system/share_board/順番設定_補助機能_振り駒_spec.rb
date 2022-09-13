require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(shakashaka_count, piece_names, message)
    a_block do
      visit_app({
          :room_code            => :my_room,
          :fixed_user_name      => "1",
          :fixed_order_names    => "1,2,3,4",
          :handle_name_validate => "false",
          :furigoma_random_key  => "is_true",        # 毎回反転が起きる
          :shakashaka_count     => shakashaka_count, # 2回すると反転の反転で表に戻る(つまり「歩」が5枚)
        })

      hamburger_click
      os_modal_handle                       # 「順番設定」モーダルを開く(すでに有効になっている)

      assert_order_setting_members ["1", "2", "3", "4"]

      find(".furigoma_handle").click
      assert_text(piece_names)
      assert_text(message)
    end
  end

  it "歩5枚" do
    case1("2", "歩歩歩歩歩", "1さんが振り駒をした結果、歩が5枚で1さんの先手になりました")
  end

  it "と金5枚" do
    case1("3", "ととととと", "1さんが振り駒をした結果、と金が5枚で2さんの先手になりました")
  end
end
