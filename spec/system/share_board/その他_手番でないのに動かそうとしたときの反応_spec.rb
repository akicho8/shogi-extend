require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1
    a_block do
      visit_room(room_key: :test_room, user_name: "alice", fixed_order_names: "alice,bob")
    end
    b_block do
      visit_room(room_key: :test_room, user_name: "bob", fixed_order_names: "alice,bob")
    end
    c_block do
      visit_room(room_key: :test_room, user_name: "carol", fixed_order_names: "alice,bob")
    end
  end
  it "時計OFF順番設定ONでは検討をしていると思われる" do
    case1
    b_block do
      place_click("77")
      assert_text("(今はaliceさんの手番です。みんなで盤をつついて検討する場合は順番設定を解除してください)")
    end
  end
  it "時計OFF順番設定ONでは検討をしていると思われるときに観戦者が操作しようとした" do
    case1
    c_block do
      place_click("77")
      assert_text("(今はaliceさんの手番です。それにあなたは観戦者なんで触らんといてください。みんなで盤をつついて検討する場合は順番設定を解除してください)")
    end
  end
  it "時計ON順番設定ONは対局中と思われる" do
    case1
    b_block do
      clock_start
      place_click("77")
      assert_text("(今はaliceさんの手番です)")
    end
  end
  it "順番設定で誰も参加していない(ユーザーの操作ではバリデーションがあるためこうはならない)" do
    visit_app({
        :room_key             => :test_room,
        :user_name            => "a",
        :fixed_member_names   => "a",
        :fixed_order_names    => "a", # 順番設定で黒側に一人aがいる
        :fixed_order_state    => "to_o2_state",
        :handle_name_validate => "false",
        :body                 => SfenGenerator.start_from(:white), # 後手から始まる
      })
    piece_move_o("33", "34", "☖3四歩") # a が代走する
    piece_move_o("77", "76", "☗7六歩") # a が自分の手を指す
  end
end
