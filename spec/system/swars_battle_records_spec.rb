require "rails_helper"

RSpec.describe "将棋ウォーズ棋譜検索", type: :system do
  before do
    swars_battle_record_setup
    @swars_battle_record = SwarsBattleRecord.first
  end

  it "トップ" do
    visit "/w"
    expect(page).to have_content "将棋ウォーズ棋譜検索"
    expect(page).to have_field "query"
    doc_image
  end

  it "検索" do
    visit "/w"
    fill_in "query", with: "hanairobiyori"
    click_button "検索"
    expect(page).to have_content "対戦相手"
    doc_image
  end

  it "戦法クラウド" do
    visit "/w-cloud"
    expect(page).to have_content "Rails"
    doc_image
  end
end
