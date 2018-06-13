require "rails_helper"

RSpec.describe "2ch棋譜検索", type: :system do
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
    fill_in "query", with: "一太郎"
    click_on("検索")
    expect(page).to have_content "結果"
    doc_image
  end
end
