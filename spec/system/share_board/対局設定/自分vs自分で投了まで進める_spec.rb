require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :room_key              => SecureRandom.hex,
        :user_name             => "a",
        :FIXED_MEMBER          => "a",
        :FIXED_ORDER           => "a",
        :self_vs_self_enable_p => true,
      })

    sidebar_open
    order_modal_open_handle
    assert_selector(".realtime_notice", text: "次は白チームを決めよう (この状態でもaさん同士で対局可)", exact_text: true)
    order_modal_close_handle
    sidebar_close

    clock_start
    assert_text "これは自分対自分の練習モードです"

    piece_move_o("77", "76", "☗7六歩")
    assert_var(:next_turn_message, "次も、aさんの手番です")
    piece_move_o("33", "34", "☖3四歩")
    resign_run

    sidebar_open

    # ランキングは表示されていない
    find(".battle_ranking_modal_open_handle").click
    assert_no_selector(".SbBattleRankingModal table")
    find(".battle_ranking_modal_close_handle").click

    # 対局履歴
    find(".battle_list_modal_open_handle").click
    assert_selector(".SbBattleListModal tr")                                                      # 対局履歴が1件ある
    assert_selector(".SbBattleListModal .memberships_cell", text: "", exact_text: true, count: 2) # しかし両対者は空である
    find(".battle_list_modal_close_handle").click
  end
end
