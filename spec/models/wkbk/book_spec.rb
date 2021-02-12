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

    it "articles_order_by_keys" do
      user = User.create!
      book = user.wkbk_books.create!
      book.articles << user.wkbk_articles.create!(key: "a")
      book.articles << user.wkbk_articles.create!(key: "b")

      assert { book.articles.order(:position).pluck(:key) == ["a", "b"] }
      book.articles_order_by_keys(["b", "a"])
      assert { book.articles.order(:position).pluck(:key) == ["b", "a"] }
    end
  end
end
