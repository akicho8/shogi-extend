require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "モーダルで開く" do
    visit_to("/share-board")
    sidebar_open
    menu_item_click("使い方")
    find(".close_handle").click
  end

  it "モーダルからパーマリンクで飛ぶ" do
    visit_to("/share-board")
    sidebar_open
    menu_item_click("使い方")
    switch_to_window_by do
      find(:link, :class => "permalink").click       # 固定URLを別タブで開く
    end
    assert_current_path "/share-board/help", ignore_query: true
  end

  it "ほぼ静的ページ" do
    visit_to("/share-board/help")
    assert_text("順番設定")
  end
end
