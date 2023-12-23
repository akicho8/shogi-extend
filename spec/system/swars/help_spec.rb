require "rails_helper"

RSpec.describe "よくある質問 (FAQ)", type: :system, swars_spec: true do
  include SwarsSystemSupport

  it "モーダルで開く" do
    visit2 "/swars/search"
    global_menu_open
    menu_item_click("よくある質問 (FAQ)")
    find(".close_handle").click
  end

  it "モーダルからパーマリンクで飛ぶ" do
    visit2 "/swars/search"
    global_menu_open
    menu_item_click("よくある質問 (FAQ)")
    switch_to_window_by do
      find(".permalink").click
    end
    assert_current_path "/swars/search/help", ignore_query: true
  end

  it "ほぼ静的ページ" do
    visit2 "/swars/search/help"
    assert_text("よくある質問 (FAQ)")
  end
end
