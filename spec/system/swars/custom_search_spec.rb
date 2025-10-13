require "rails_helper"

RSpec.describe "カスタム検索", type: :system, swars_spec: true do
  include SwarsSystemSupport

  it "サイドバーから遷移" do
    visit_to "/swars/search", query: "YamadaTaro"
    sidebar_open
    find(".swars_search_custom_handle").click
    assert_current_path "/swars/search/custom?user_key=YamadaTaro"
  end

  it "フォーム入力からの検索" do
    visit_to "/swars/search/custom", user_key: "YamadaTaro"
    find(:label, text: "10分", exact_text: true).click
    within(".new_query_field") do
      assert_selector(:fillable_field, with: "YamadaTaro 持ち時間:10分")
    end
    click_on("検索")
    assert_current_path "/swars/search", ignore_query: true
  end

  it "ウォーズIDが入力されていない場合にエラーメッセージが出るのと検索ボタンがdisabledになる" do
    visit_to "/swars/search/custom", query: ""
    assert_selector(:button, text: "検索", exact_text: true, disabled: true) # 検索ボタンが押せない
    assert_text("1つだけ入力してください")
  end
end
