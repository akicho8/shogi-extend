require "#{__dir__}/sb_support_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app
    sidebar_open
    menu_item_click("局面編集")
    find(".CustomShogiPlayer .ToolBelt .EditToolInfo").click    # 左から2つ目の dropdown をクリック
    menu_item_sub_menu_click("駒箱: セット")
    piece_move("77", "76")                                # 駒移動で edit の sfen の emit が飛ぶ
    assert_selector(".PieceBox .PieceTap")                # でも駒箱の駒は消えていない
  end
end
