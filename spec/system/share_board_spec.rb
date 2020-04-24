require "rails_helper"

RSpec.describe "指し継ぎリレー将棋", type: :system do
  it "最初" do
    visit "/share-board"
    expect(page).to have_content "0手目"
    doc_image
  end

  it "メニュー表示" do
    visit "/share-board"
    find(".share_board .dropdown_menu").click
    expect(page).to have_content "棋譜読み込み"
    doc_image
  end
end
