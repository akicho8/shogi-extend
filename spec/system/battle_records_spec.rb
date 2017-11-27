require "rails_helper"

RSpec.describe "将棋ウォーズ棋譜検索", type: :system do
  before do
    unless BattleRank.exists?
      StaticBattleRankInfo.each do |e|
        BattleRank.create!(unique_key: e.key, priority: e.priority)
      end
    end

    BattleRecord.import_all(battle_user_key: "hanairobiyori")
    @battle_record = BattleRecord.first
  end

  it "フォーム表示→入力→実行→結果" do
    visit "/s"
    expect(page).to have_content "将棋ウォーズ棋譜検索"

    expect(page).to have_field "battle_user_key"

    fill_in "battle_user_key", with: "hanairobiyori"
    click_button "検索"

    expect(page).to have_content "対戦相手"
  end
end
