require "rails_helper"

RSpec.describe "なんでも棋譜変換", type: :system do
  it "フォームを開く" do
    visit "http://localhost:4000/adapter"
    expect(page).to have_content "なんでも棋譜変換"
    doc_image
  end

  it "正常系" do
    visit "http://localhost:4000/adapter"
    find("textarea").set("68S")
    find(".KifCopyButton").click
    expect(page).to have_content "コピーしました"
    doc_image
  end

  it "エラー" do
    visit "http://localhost:4000/adapter"
    find("textarea").set("11玉")
    find(".KifCopyButton").click
    expect(page).to have_content "駒の上に打とうとしています"
    doc_image
  end

  # http://0.0.0.0:3000/adapter?body=foo
  it "bodyパラメータで棋譜を渡せる" do
    visit "http://localhost:4000/adapter?body=(foo)"
    value = find("textarea").value
    assert { value == "(foo)" }
    doc_image
  end
end
