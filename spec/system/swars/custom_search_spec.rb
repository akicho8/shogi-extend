require "rails_helper"

RSpec.describe "カスタム検索", type: :system, swars_spec: true do
  include SwarsSystemSupport

  it "サイドバーから遷移" do
    visit2 "/swars/search", query: "Yamada_Taro"
    hamburger_click
    find(".swars_custom_search_handle").click
    assert_current_path "/swars/search/custom?user_key=Yamada_Taro"
  end

  it "フォーム入力からの検索" do
    visit2 "/swars/search/custom", user_key: "Yamada_Taro"
    find(:label, text: "10分", exact_text: true).click
    within(".new_query_field") do
      assert_selector(:fillable_field, with: "Yamada_Taro 持ち時間:10分")
    end
    click_on("検索")
    assert_current_path "/swars/search", ignore_query: true
  end
end
