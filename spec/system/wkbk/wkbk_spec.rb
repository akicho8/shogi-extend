require "rails_helper"

RSpec.describe "将棋ドリル", type: :system do
  it "問題集トップ" do
    visit_to "/rack"
    assert_text "問題集"
  end

  it "問題集一覧" do
    visit_to "/rack/books"
    assert_text "問題集"
  end

  it "問題集詳細" do
    visit_to "/rack/books/1"
    assert_text "admin - public", wait: 5
  end

  it "問題集編集" do
    visit_to "/rack/books/1/edit?_login_by_key=admin"
    assert_text ""
  end

  it "問題一覧" do
    visit_to "/rack/articles"
    assert_text "問題"
  end

  it "問題詳細" do
    visit_to "/rack/articles/1"
    assert_text "public"
  end

  it "問題編集" do
    visit_to "/rack/articles/1/edit?_login_by_key=admin"
  end

  it "問題新規" do
    login
    visit_to "/rack/articles/new"
    assert_text("玉回収")
  end
end
