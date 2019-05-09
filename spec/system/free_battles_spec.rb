require "rails_helper"

RSpec.describe "棋譜投稿", type: :system do
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
    # expect(page).to have_field "free_battle[kifu_url]"
    # expect(page).to have_field "free_battle[kifu_file]"

    fill_in "free_battle[kifu_body]", with: "68銀"
    sleep(3)
    doc_image("入力")
    click_button "保存"

    expect(page).to have_content "嬉野流"
    expect(page).to have_content "６八銀"

    doc_image("詳細")
  end

  it "コピペ新規" do
    visit "/x/#{@free_battle.id}"
    click_on "コピペ新規"
    text_input_click
    expect(page).to have_content "48玉"
    doc_image
  end

  it "詳細" do
    visit "/x/#{@free_battle.id}"
    expect(page).to have_content "新米長玉"
  end

  # click_on("テキスト入力") 相当
  def text_input_click
    find(".input_method_tabs .tabs li:nth-child(2)").click
  end
end
