require "rails_helper"

RSpec.describe "将棋ウォーズ棋譜検索", type: :system do
  before do
    battle_record_setup
    @battle_record = BattleRecord.first
  end

  it "フォーム表示→入力→実行→結果" do
    visit "/s"
    expect(page).to have_content "将棋ウォーズ棋譜検索"

    expect(page).to have_field "query"

    fill_in "query", with: "hanairobiyori"
    click_button "検索"

    expect(page).to have_content "対戦相手"

    expect(page).to have_content "詳細"
    expect(page).to have_content "コピー"

    fill_in "query", with: "美濃囲い"
    click_button "検索"

    # うごかん
    # click_link "詳細"
  end
end
