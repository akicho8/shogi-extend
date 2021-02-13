# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Book (wkbk_books as Wkbk::Book)
#
# |-----------------+--------------------+--------------+---------------------+--------------+-------|
# | name            | desc               | type         | opts                | refs         | index |
# |-----------------+--------------------+--------------+---------------------+--------------+-------|
# | id              | ID                 | integer(8)   | NOT NULL PK         |              |       |
# | key             | ユニークなハッシュ | string(255)  | NOT NULL            |              | A!    |
# | user_id         | User               | integer(8)   | NOT NULL            | => ::User#id | B     |
# | folder_id       | Folder             | integer(8)   | NOT NULL            |              | C     |
# | sequence_id     | Sequence           | integer(8)   | NOT NULL            |              | D     |
# | title           | タイトル           | string(100)  | NOT NULL            |              |       |
# | description     | 説明               | string(5000) | NOT NULL            |              |       |
# | bookships_count | Bookships count    | integer(4)   | DEFAULT(0) NOT NULL |              |       |
# | created_at      | 作成日時           | datetime     | NOT NULL            |              |       |
# | updated_at      | 更新日時           | datetime     | NOT NULL            |              |       |
# |-----------------+--------------------+--------------+---------------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require 'rails_helper'

module Wkbk
  RSpec.describe Book, type: :model do
    include WkbkSupportMethods
    include ActiveJob::TestHelper # for perform_enqueued_jobs

    it "works" do
      assert { Book.first }
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

    it "sequenced_articles" do
      user = User.create!
      book = user.wkbk_books.create!(sequence_key: :article_difficulty_desc)
      book.articles << user.wkbk_articles.create!(difficulty: 1, folder_key: :public)
      book.articles << user.wkbk_articles.create!(difficulty: 2, folder_key: :public)
      book.articles << user.wkbk_articles.create!(difficulty: 3, folder_key: :private)
      alice = User.create!
      assert { book.sequenced_articles(alice).collect(&:difficulty) == [2, 1] }
    end

    it "[TODO] as_json するまえに articles を preload しても as_json のタイミングで再度 O(n) のSQLが発生する再現" do
      user = User.create!
      book = user.wkbk_books.create!
      3.times do
        book.articles << user.wkbk_articles.create!
      end

      # logger = ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
      # ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)

      book.bookships.preload(:article).to_a
      book.as_json(::Wkbk::Book.json_struct_for_edit)
    end
  end
end
