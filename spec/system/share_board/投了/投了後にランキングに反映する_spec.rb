require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    setup_share_board
    visit_room({
        :user_name    => :a,
        :FIXED_MEMBER => "a,b",
        :FIXED_ORDER  => "a,b",
        :room_after_create => :cc_auto_start_10m,
      })
    resign_run
    sidebar_open

    # 対局履歴
    find(".battle_list_modal_open_handle").click
    assert_selector(".SbBattleListModal .user_name", text: "a", exact_text: true)
    assert_selector(".SbBattleListModal .user_name", text: "b", exact_text: true)
    find(".battle_list_modal_close_handle").click

    # ランキング
    find(".battle_ranking_modal_open_handle").click
    assert_selector(".SbBattleRankingModal .user_name", text: "a", exact_text: true)
    assert_selector(".SbBattleRankingModal .user_name", text: "b", exact_text: true)
    find(".battle_ranking_modal_close_handle").click
  end
end
