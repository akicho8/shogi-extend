require "rails_helper"

RSpec.describe "FreeBattleRecords", type: :system do
  before do
    @free_battle_record = FreeBattleRecord.create!
  end

  it "一覧" do
    visit "/x"
    expect(page).to have_content "一覧"
  end

  it "入力→変換→完了" do
    visit "/x/new"

    expect(page).to have_field "free_battle_record[kifu_body]"
    expect(page).to have_field "free_battle_record[kifu_url]"
    expect(page).to have_field "free_battle_record[kifu_file]"

    fill_in "free_battle_record[kifu_body]", with: "76歩"
    click_button "変換"

    expect(page).to have_content "結果"
    expect(page).to have_content "▲７六歩"
  end
end
