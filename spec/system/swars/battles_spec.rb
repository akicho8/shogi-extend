require "rails_helper"

RSpec.describe "将棋ウォーズ棋譜検索", type: :system do
  before do
    swars_battle_setup
    @battle = Swars::Battle.first
  end

  it "トップ" do
    visit "/w"
    expect(page).to have_content "将棋ウォーズ棋譜検索"
    expect(page).to have_field "query"
    doc_image
  end

  it "検索" do
    visit "/w"
    fill_in "query", with: "devuser1"
    click_button "検索"
    expect(page).to have_content "相手"
    doc_image
  end

  it "ぴよ将棋専用" do
    visit "/w-light"
    fill_in "query", with: "devuser1"
    click_button "検索"
    expect(page).to have_content "相手"
    doc_image
  end

  it "アプリ起動できるブックマーク可能なページに飛ぶ" do
    visit "/w-light?query=devuser1"
    click_on "こちら"
    expect(page).to have_content "ホーム画面に追加してください"
    doc_image
  end

  it "連打対策" do
    visit "/w?query=devuser1&raise_duplicate_key_error=1"
    expect(page).to have_content "データ収集中なのであと15秒ぐらいしてからお試しください"
    doc_image
  end

  it "戦法クラウド" do
    visit "/w-cloud"
    expect(page).to have_content "Rails"
    doc_image
  end
end
