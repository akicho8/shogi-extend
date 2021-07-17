require "rails_helper"

RSpec.describe "インスタント将棋問題集", type: :system do
  before do
    # FIXME: テスト対象は development なのでこれらは意味ない
    Actb.setup
    Emox.setup
    Wkbk.setup
    Wkbk::Book.mock_setup
    # tp Wkbk.info
    # tp Wkbk::Book
  end

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
    visit "/rack/books/1/edit?_user_id=#{User.sysop.id}"
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
    visit "/rack/articles/1/edit?_user_id=#{User.sysop.id}"
    doc_image
  end
end
