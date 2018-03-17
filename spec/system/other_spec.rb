require "rails_helper"

RSpec.describe "その他", type: :system do
  it "トップ" do
    visit "/"
    expect(page).to have_content "Rails"
  end

  it "符号入力ゲーム" do
    visit "/xy"
    expect(page).to have_content "Rails"
  end

  it "戦法一覧" do
    visit "/tactics"
    expect(page).to have_content "Rails"
  end

  it "戦法詳細" do
    visit "/tactics/ダイヤモンド美濃"
    expect(page).to have_content "Rails"
  end

  it "戦法ツリー" do
    visit "/tactics-tree"
    expect(page).to have_content "Rails"
  end

  it "今日の戦法占い" do
    visit "/tactics-fortune"
    expect(page).to have_content "Rails"
  end
end
