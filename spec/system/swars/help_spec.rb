require "rails_helper"

RSpec.describe "よくある質問 (FAQ)", type: :system, swars_spec: true do
  include SwarsSystemSupport

  it "モーダルで開く" do
    visit2 "/swars/search"
    hamburger_click
    menu_item_click("よくある質問 (FAQ)")
    find(".close_handle").click
  end

  it "モーダルからパーマリンクで飛ぶ" do
    visit2 "/swars/search"
    hamburger_click
    menu_item_click("よくある質問 (FAQ)")
    find(".permalink").click       # 固定URLを別タブで開く
    switch_to_window_last # 別タブに移動する
    assert_current_path "/swars/search/help", ignore_query: true
  end

  it "ほぼ静的ページ" do
    visit2 "/swars/search/help"
    assert_text("よくある質問 (FAQ)")
  end
end
