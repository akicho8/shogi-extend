require "rails_helper"

RSpec.describe "みんなの将棋問題集", type: :system do
  before do
    Actb.setup
    Emox.setup
    Wkbk.setup
    Wkbk::Book.mock_setup
    # tp Wkbk.info
    # tp Wkbk::Book
  end

  it "問題集トップ" do
    visit "http://0.0.0.0:4000/library"
    expect(page).to have_content "問題集"
    doc_image
  end

  it "問題集一覧" do
    visit "http://0.0.0.0:4000/library/books"
    expect(page).to have_content "問題集"
    doc_image
  end

  it "問題集詳細" do
    visit "http://0.0.0.0:4000/library/books/1"
    expect(page).to have_content "sysop - public"
    doc_image
  end

  it "問題集編集" do
    visit "http://0.0.0.0:4000/library/books/1/edit?_user_id=#{User.sysop.id}"
    expect(page).to have_content ""
    doc_image
  end

  it "問題一覧" do
    visit "http://0.0.0.0:4000/library/articles"
    expect(page).to have_content "問題"
    doc_image
  end

  it "問題詳細" do
    visit "http://0.0.0.0:4000/library/articles/1"
    expect(page).to have_content "public"
    doc_image
  end

  it "問題編集" do
    visit "http://0.0.0.0:4000/library/articles/1/edit?_user_id=#{User.sysop.id}"
    doc_image
  end
end
