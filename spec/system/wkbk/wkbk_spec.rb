require "rails_helper"

RSpec.describe "将棋ドリル", type: :system do
  it "問題集トップ" do
    visit2 "/rack"
    assert_text "問題集"
  end

  it "問題集一覧" do
    visit2 "/rack/books"
    assert_text "問題集"
  end

  it "問題集詳細" do
    visit2 "/rack/books/1"
    assert_text "sysop - public"
  end

  it "問題集編集" do
    visit2 "/rack/books/1/edit?_login_by_key=sysop"
    assert_text ""
  end

  it "問題一覧" do
    visit2 "/rack/articles"
    assert_text "問題"
  end

  it "問題詳細" do
    visit2 "/rack/articles/1"
    assert_text "public"
  end

  it "問題編集" do
    visit2 "/rack/articles/1/edit?_login_by_key=sysop"
  end

  it "問題新規" do
    login
    visit2 "/rack/articles/new"
    assert_text("玉回収")
  end
end
