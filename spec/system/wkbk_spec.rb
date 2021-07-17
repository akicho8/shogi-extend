require "rails_helper"

RSpec.describe "インスタント将棋問題集", type: :system do
  it "問題集トップ" do
    visit "/rack"
    assert_text "問題集"
    doc_image
  end

  it "問題集一覧" do
    visit "/rack/books"
    assert_text "問題集"
    doc_image
  end

  it "問題集詳細" do
    visit "/rack/books/1"
    assert_text "sysop - public"
    doc_image
  end

  it "問題集編集" do
    visit "/rack/books/1/edit?_login_by_key=sysop"
    assert_text ""
    doc_image
  end

  it "問題一覧" do
    visit "/rack/articles"
    assert_text "問題"
    doc_image
  end

  it "問題詳細" do
    visit "/rack/articles/1"
    assert_text "public"
    doc_image
  end

  it "問題編集" do
    visit "/rack/articles/1/edit?_login_by_key=sysop"
    doc_image
  end
end
