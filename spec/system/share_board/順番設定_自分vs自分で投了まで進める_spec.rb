require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :room_key              => SecureRandom.hex,
        :user_name             => "a",
        :FIXED_MEMBER          => "a",
        :FIXED_ORDER           => "a",
        :self_vs_self_enable_p => true,
      })

    os_modal_open
    # assert_selector(".realtime_notice", text: "1 vs 1 で対局を開始できます", exact_text: true)
    # debugger
    # drag_a_to_b(:is_team_white, 0, :is_team_black)
    assert_selector(".realtime_notice", text: "☖にも入れてください (この状態でもaさん同士で対局可)", exact_text: true)

    os_modal_close
    clock_start

    piece_move_o("77", "76", "☗7六歩")
    piece_move_o("33", "34", "☖3四歩")
    give_up_run

    sidebar_open
    menu_item_click("対局履歴")

    assert_no_selector(".SbDashboardUserRanking")                                                      # ランキングは表示されていない
    assert_selector(".SbDashboardBattleIndex tr")                                                      # 対局履歴が1件ある
    assert_selector(".SbDashboardBattleIndex .memberships_cell", text: "", exact_text: true, count: 2) # しかし両対者は空である
  end
end
