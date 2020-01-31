require "rails_helper"

RSpec.describe "なんでも棋譜変換", type: :system do
  it "フォームを開く" do
    visit "/adapter"
    expect(page).to have_content "なんでも棋譜変換"
    doc_image
  end

  it "正常系" do
    visit "/adapter"
    find("textarea").set("68S")
    find(".kif_copy_link").click
    expect(page).to have_content "クリップボードにコピーしました"
    doc_image
  end

  it "エラー" do
    visit "/adapter"
    find("textarea").set("11玉")
    find(".kif_copy_link").click
    expect(page).to have_content "駒の上に打とうとしています"
    doc_image
  end
end
