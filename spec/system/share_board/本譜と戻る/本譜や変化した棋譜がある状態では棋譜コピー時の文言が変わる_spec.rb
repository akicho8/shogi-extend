require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app(body: "position startpos")        # 棋譜がある状態で来た
    sidebar_menu_item_click("棋譜コピー (KIF)") # 本譜があるので
    assert_text "本譜をコピーしました"          # 本譜をコピーした
    piece_move("77", "76")                      # そこで分岐するすると変化するので
    sidebar_menu_item_click("棋譜コピー (KIF)") # コピーすると
    assert_text "変化した棋譜をコピーしました"  # 変化した棋譜であることを伝える
  end
end
