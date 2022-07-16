require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "モーダルで開く" do
    visit2("/share-board")
    hamburger_click
    menu_item_click("使い方")
    find(".close_handle").click
  end

  it "モーダルからパーマリンクで飛ぶ" do
    visit2("/share-board")
    hamburger_click
    menu_item_click("使い方")
    window = window_opened_by do
      find(:link, :class => "permalink").click       # 固定URLを別タブで開く
    end
    switch_to_window(window) # 別タブに移動する
    assert_current_path "/share-board/help", ignore_query: true
  end

  it "ほぼ静的ページ" do
    visit2("/share-board/help")
    assert_text("リレー将棋")
  end
end
