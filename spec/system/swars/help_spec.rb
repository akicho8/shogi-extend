require "rails_helper"

RSpec.describe "使い方", type: :system, swars_spec: true do
  include SwarsSystemSupport

  it "モーダルで開く" do
    visit "/swars/search"
    hamburger_click
    menu_item_click("使い方")
    find(".close_handle").click
  end

  it "モーダルからパーマリンクで飛ぶ" do
    visit "/swars/search"
    hamburger_click
    menu_item_click("使い方")
    find(".permalink").click       # 固定URLを別タブで開く
    switch_to_window_last # 別タブに移動する
    assert { current_path == "/swars/help" }
  end

  it "ほぼ静的ページ" do
    visit "/swars/help"
    assert_text("使い方")
  end
end
