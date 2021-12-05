# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Book (wkbk_books as Wkbk::Book)
#
# |-------------------+-------------------+-------------+---------------------+--------------+-------|
# | name              | desc              | type        | opts                | refs         | index |
# |-------------------+-------------------+-------------+---------------------+--------------+-------|
# | id                | ID                | integer(8)  | NOT NULL PK         |              |       |
# | key               | キー              | string(255) | NOT NULL            |              | A!    |
# | user_id           | User              | integer(8)  | NOT NULL            | => ::User#id | B     |
# | folder_id         | Folder            | integer(8)  | NOT NULL            |              | C     |
# | sequence_id       | Sequence          | integer(8)  | NOT NULL            |              | D     |
# | title             | タイトル          | string(100) | NOT NULL            |              |       |
# | description       | 説明              | text(65535) | NOT NULL            |              |       |
# | bookships_count   | Bookships count   | integer(4)  | DEFAULT(0) NOT NULL |              |       |
# | answer_logs_count | Answer logs count | integer(4)  | DEFAULT(0) NOT NULL |              |       |
# | created_at        | 作成日時          | datetime    | NOT NULL            |              |       |
# | updated_at        | 更新日時          | datetime    | NOT NULL            |              |       |
# | access_logs_count | Access logs count | integer(4)  | DEFAULT(0) NOT NULL |              | E     |
# |-------------------+-------------------+-------------+---------------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require "rails_helper"

module Wkbk
  RSpec.describe Book, type: :model do
    include WkbkSupportMethods
    include ActiveJob::TestHelper # for perform_enqueued_jobs

    it "works" do
      assert { Book.first }
    end

    it "sorted" do
      assert { Book.sorted(sort_column: "id",        sort_order: "asc") }
      assert { Book.sorted(sort_column: "user.id",   sort_order: "asc") }
      assert { Book.sorted(sort_column: "folder.id", sort_order: "asc") }
    end

    it "ordered_bookships" do
      assert { Book.first.ordered_bookships }
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

    describe "general_search" do
      it "クエリとタグ検索が正しい" do
        Wkbk::Book.destroy_all
        user = User.create!
        user.wkbk_books.create!(title: "aa", tag_list: "t1", folder_key: "public")
        user.wkbk_books.create!(title: "bb", tag_list: "t2", folder_key: "public")
        assert { Book.general_search(query: "a").size === 1 }
        assert { Book.general_search(query: "a", tag: "t1").size === 1 }
        assert { Book.general_search(query: "x", tag: "t1").size === 0 }
      end

      it "カタカナをひらがなで検索できる" do
        Wkbk::Book.destroy_all
        user = User.create!
        book = user.wkbk_books.create!(title: "アヒル", folder_key: "public")
        assert { Book.general_search(query: "あ").size === 1 }
      end

      describe "公開設定でスコープできる" do
        before do
          Wkbk::Book.destroy_all
          @user = User.create!
          @user.wkbk_books.create!(folder_key: "public")
          @user.wkbk_books.create!(folder_key: "limited")
          @user.wkbk_books.create!(folder_key: "private")
        end

        def test1(search_preset_key)
          Book.general_search(search_preset_key: search_preset_key, current_user: @user).collect(&:folder_key)
        end

        it "works" do
          assert { test1("公開")     == ["public"]  }
          assert { test1("限定公開") == ["limited"] }
          assert { test1("非公開")   == ["private"] }
        end
      end

      it "queryとtagとsearch_preset_keyがある(joinとorが複合するときcompatibleエラーになりやすい)" do
        Wkbk::Book.destroy_all
        user = User.create!
        user.wkbk_books.create!(title: "(title)", tag_list: "(tag)", folder_key: "public")
        assert { Book.general_search(query: "(title)", tag: "(tag)", search_preset_key: "公開", current_user: user).size == 1 }
      end
    end

    describe "notify" do
      it "works" do
        user = User.create!
        book = user.wkbk_books.create!
        perform_enqueued_jobs { book.notify }
        mail = ActionMailer::Base.deliveries.last
        assert { mail.to   == ["shogi.extend@gmail.com"] }
        assert { mail.subject.match?(/問題集.*作成/) }
      end
    end
  end
end
