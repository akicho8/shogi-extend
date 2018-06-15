require "rails_helper"

RSpec.describe "2ch棋譜", type: :system do
  before do
    general_battle_setup
  end

  it "トップ" do
    visit "/s"
    expect(page).to have_content "2ch棋譜検索"
    expect(page).to have_field "query"
    doc_image
  end

  it "検索" do
    visit "/s"
    find("#search_form input[type=search]").set("一太郎")
    find("#search_form button").click
    expect(page).to have_content "一太郎 ZIP ダウンロード"
    doc_image
  end
end
