require "rails_helper"

RSpec.describe "よくある質問 (FAQ)", type: :system, swars_spec: true do
  it "開く" do
    visit_to "/swars/search"
    global_menu_open
    menu_item_click("よくある質問 (FAQ)")
    assert_current_path "/swars/search/help", ignore_query: true
  end

  it "ほぼ静的ページ" do
    visit_to "/swars/search/help"
    assert_text("よくある質問")
  end
end
