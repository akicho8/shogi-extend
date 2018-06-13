require "rails_helper"

RSpec.describe "棋譜変換", type: :system do
  before do
    @free_battle = FreeBattle.create!
  end

  it "一覧" do
    visit "/x"
    expect(page).to have_content "一覧"
  end

  it "変換" do
    visit "/x/new"

    expect(page).to have_field "free_battle[kifu_body]"
    expect(page).to have_field "free_battle[kifu_url]"
    expect(page).to have_field "free_battle[kifu_file]"

    fill_in "free_battle[kifu_body]", with: "68銀"
    sleep(3)
    doc_image("入力")
    click_button "変換"

    expect(page).to have_content "結果"
    expect(page).to have_content "▲６八銀"

    doc_image("結果")
  end
end
