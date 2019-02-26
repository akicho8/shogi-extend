require "rails_helper"

RSpec.describe "棋譜入力", type: :system do
  before do
    @free_battle = FreeBattle.create!
  end

  it "一覧" do
    visit "/x"
    expect(page).to have_content "一覧"
  end

  it "固定URL化" do
    visit "/x/new"

    expect(page).to have_field "free_battle[kifu_body]"
    expect(page).to have_field "free_battle[kifu_url]"
    expect(page).to have_field "free_battle[kifu_file]"

    fill_in "free_battle[kifu_body]", with: "68銀"
    sleep(3)
    doc_image("入力")
    click_button "固定URL化"

    expect(page).to have_content "嬉野流"
    expect(page).to have_content "▲６八銀"

    doc_image("詳細")
  end
end
