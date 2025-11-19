# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Book (wkbk_books as Wkbk::Book)
#
# |-------------------+-------------------+-------------+---------------------+------+-------|
# | name              | desc              | type        | opts                | refs | index |
# |-------------------+-------------------+-------------+---------------------+------+-------|
# | id                | ID                | integer(8)  | NOT NULL PK         |      |       |
# | key               | キー              | string(255) | NOT NULL            |      | A!    |
# | user_id           | User              | integer(8)  | NOT NULL            |      | B     |
# | folder_id         | Folder            | integer(8)  | NOT NULL            |      | C     |
# | sequence_id       | Sequence          | integer(8)  | NOT NULL            |      | D     |
# | title             | タイトル          | string(100) | NOT NULL            |      |       |
# | description       | 説明              | text(65535) | NOT NULL            |      |       |
# | bookships_count   | Bookships count   | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | answer_logs_count | Answer logs count | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | created_at        | 作成日時          | datetime    | NOT NULL            |      |       |
# | updated_at        | 更新日時          | datetime    | NOT NULL            |      |       |
# | access_logs_count | Access logs count | integer(4)  | DEFAULT(0) NOT NULL |      | E     |
# |-------------------+-------------------+-------------+---------------------+------+-------|
#
# - Remarks ----------------------------------------------------------------------
# [Warning: Need to add relation] Wkbk::Book モデルに belongs_to :sequence を追加しよう
# [Warning: Need to add relation] Wkbk::Book モデルに belongs_to :user を追加しよう
# --------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe Wkbk::Book, type: :model do
  include WkbkSupportMethods
  include ActiveJob::TestHelper # for perform_enqueued_jobs

  it "works" do
    assert { Wkbk::Book.first }
  end

  it "sorted" do
    assert { Wkbk::Book.sorted(sort_column: "id",        sort_order: "asc") }
    assert { Wkbk::Book.sorted(sort_column: "user.id",   sort_order: "asc") }
    assert { Wkbk::Book.sorted(sort_column: "folder.id", sort_order: "asc") }
  end

  it "ordered_bookships" do
    assert { Wkbk::Book.first.ordered_bookships }
  end

  it "bookships_order_by_ids" do
    user = User.create!
    book = user.wkbk_books.create!
    book.articles << user.wkbk_articles.create!(key: "a")
    book.articles << user.wkbk_articles.create!(key: "b")
    ids = book.ordered_bookship_ids

    assert { book.articles.order(:position).pluck(:key) == ["a", "b"] }
    book.bookships_order_by_ids(ids.reverse)
    assert { book.articles.order(:position).pluck(:key) == ["b", "a"] }
  end

  it "to_xitems" do
    user = User.create!
    book = user.wkbk_books.create!(sequence_key: :article_difficulty_desc)
    book.articles << user.wkbk_articles.create!(difficulty: 1, folder_key: :public)
    book.articles << user.wkbk_articles.create!(difficulty: 2, folder_key: :public)
    book.articles << user.wkbk_articles.create!(difficulty: 3, folder_key: :private)
    other_user = User.create!
    records = book.to_xitems(other_user)
    assert { records.collect { |e| e[:article]["difficulty"] } == [3, 2, 1] } # private も空として含めるため3がある
    assert { records[0][:article]["title"] == nil }                           # private なので title を nil にしている
  end

  it "[TODO] as_json するまえに articles を preload しても as_json のタイミングで再度 O(n) のSQLが発生する再現" do
    user = User.create!
    book = user.wkbk_books.create!
    book.articles << user.wkbk_articles.create!
    book.articles << user.wkbk_articles.create!
    book.articles << user.wkbk_articles.create!
    book.bookships.preload(:article).to_a
    book.as_json(::Wkbk::Book.json_struct_for_edit)
  end

  describe "検索" do
    before do
      Wkbk::Book.destroy_all
      @user = User.create!(name: "(alice)")
      @book = @user.wkbk_books.create!(title: "(ア)", description: "(description)", tag_list: ["a", "b"], folder_key: "public")
      @user.wkbk_access_logs.create!(book: @book)
    end

    it "ユーザー名で検索できる" do
      assert { Wkbk::Book.general_search(query: "(alice)").present? }
    end

    it "説明を検索できる" do
      assert { Wkbk::Book.general_search(query: "(description)").present? }
      assert { Wkbk::Book.general_search(query: "unknown").blank? }
    end

    it "カタカナをひらがなで検索できる" do
      assert { Wkbk::Book.general_search(query: "あ").present? }
      assert { Wkbk::Book.general_search(query: "ん").blank? }
    end

    it "タグ検索できる" do
      assert { Wkbk::Book.general_search(tag: "a").present?   }
      assert { Wkbk::Book.general_search(tag: "b").present?   }
      assert { Wkbk::Book.general_search(tag: "a,b").present? }
      assert { Wkbk::Book.general_search(tag: "c").blank?     }
    end

    it "公開設定" do
      assert { Wkbk::Book.general_search(current_user: @user, search_preset_key: "公開").present? }
      assert { Wkbk::Book.general_search(current_user: @user, search_preset_key: "限定公開").blank? }
      assert { Wkbk::Book.general_search(current_user: @user, search_preset_key: "非公開").blank? }
    end

    it "戦法" do
      assert { Wkbk::Book.general_search(search_preset_key: "居飛車").blank? }
      assert { Wkbk::Book.general_search(search_preset_key: "右玉").blank? }
    end

    it "join問題が起きない" do
      assert { Wkbk::Book.general_search(current_user: @user, query: "ア", tag: "a", search_preset_key: "公開").present? }
    end

    it "履歴" do
      assert { Wkbk::Book.general_search(current_user: @user, query: "ア", tag: "a", search_preset_key: "履歴").present? }
    end
  end

  describe "notify" do
    it "works" do
      user = User.create!
      book = user.wkbk_books.create!
      assert { book.mail_body }
      assert { book.mail_subject }
    end
  end
end
