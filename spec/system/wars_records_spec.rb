require "rails_helper"

RSpec.describe "将棋ウォーズ棋譜検索", type: :system do
  before do
    unless WarsRank.exists?
      StaticWarsRankInfo.each do |e|
        WarsRank.create!(unique_key: e.key, priority: e.priority)
      end
    end

    WarsRecord.import_all(user_key: "hanairobiyori")
    @wars_record = WarsRecord.first
  end

  it "フォーム表示→入力→実行→結果" do
    visit "/s"
    expect(page).to have_content "将棋ウォーズ棋譜検索"

    expect(page).to have_field "user_key"

    fill_in "user_key", with: "hanairobiyori"
    click_button "検索"

    expect(page).to have_content "対戦相手"
  end
end
