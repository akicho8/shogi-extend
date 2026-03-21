require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app(body: "position startpos")        # 棋譜がある状態で来た

    sidebar_open
    find(".kifu_copy_handle_main").click
    assert_text "本譜をコピーしました"          # 本譜をコピーした
    sidebar_close

    piece_move("77", "76")                      # そこで分岐するすると変化するので

    sidebar_open
    assert_text "棋譜が本譜から分岐しています (本譜が必要であれば本譜に戻してください)" # エクスポートの欄に注意文が出ている

    find(".kifu_copy_handle_main").click
    assert_text "コピーしましたがこれは本譜ではありません"  # 変化した棋譜であることを伝える

    sidebar_close
  end
end
