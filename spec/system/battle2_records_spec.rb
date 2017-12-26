require "rails_helper"

RSpec.describe "2ch棋譜検索", type: :system do
  before do
    battle2_record_setup
    @battle2_record = Battle2Record.first
  end

  it "フォーム表示→入力→実行→結果" do
    visit "/s"
    expect(page).to have_content "2ch棋譜検索"

    expect(page).to have_field "query"

    fill_in "query", with: "一太郎"
    click_button "検索"

    expect(page).to have_content "対戦相手"

    expect(page).to have_content "詳細"
    expect(page).to have_content "コピー"

    fill_in "query", with: "女流"
    click_button "検索"

    # うごかん
    # click_link "詳細"
  end
end
