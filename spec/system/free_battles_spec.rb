require "rails_helper"

RSpec.describe "棋譜入力", type: :system do
  before do
    @free_battle = FreeBattle.create!(kifu_body: "48玉")
  end

  it "一覧" do
    visit "/x"
    expect(page).to have_content "一覧"
  end

  it "入力" do
    visit "/x/new"

    text_input_click

    expect(page).to have_field "free_battle[kifu_body]"
    expect(page).to have_field "free_battle[kifu_url]"
    expect(page).to have_field "free_battle[kifu_file]"

    fill_in "free_battle[kifu_body]", with: "68銀"
    sleep(3)
    doc_image("入力")
    click_button "保存 (固定URL化)"

    expect(page).to have_content "嬉野流"
    expect(page).to have_content "６八銀"

    doc_image("詳細")
  end

  it "新規でコピペ" do
    visit "/x/#{@free_battle.id}"
    click_on "新規でコピペ"
    text_input_click
    expect(page).to have_content "48玉"
    doc_image
  end

  it "詳細" do
    visit "/x/#{@free_battle.id}"
    expect(page).to have_content "新米長玉"
  end

  # 「テキスト入力」をクリック
  def text_input_click
    find("form nav li:nth-child(2) a").click
  end
end
