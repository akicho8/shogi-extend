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

    it "sequenced_xitems" do
      user = User.create!
      book = user.wkbk_books.create!(sequence_key: :article_difficulty_desc)
      book.articles << user.wkbk_articles.create!(difficulty: 1, folder_key: :public)
      book.articles << user.wkbk_articles.create!(difficulty: 2, folder_key: :public)
      book.articles << user.wkbk_articles.create!(difficulty: 3, folder_key: :private)
      alice = User.create!
      assert { book.sequenced_xitems(alice).collect(&:difficulty) == [2, 1] }
    end

    it "正誤情報を付与した sequenced_xitems" do
      user = User.create!
      book = user.wkbk_books.create!
      book.articles << user.wkbk_articles.create! # 0 o:2 x:1
      book.articles << user.wkbk_articles.create! # 1 o:0 x:1
      book.articles << user.wkbk_articles.create! # 2 o:0 x:0

      o = ::Wkbk::AnswerKind.fetch("correct")
      x = ::Wkbk::AnswerKind.fetch("mistake")
      answer_log = user.wkbk_answer_logs.create!(article: book.articles[0], answer_kind: o, book: book)
      answer_log = user.wkbk_answer_logs.create!(article: book.articles[0], answer_kind: o, book: book)
      answer_log = user.wkbk_answer_logs.create!(article: book.articles[0], answer_kind: x, book: book)
      answer_log = user.wkbk_answer_logs.create!(article: book.articles[1], answer_kind: x, book: book)

      articles = book.sequenced_xitems(user)
      tp articles
      # |-----+-------------+---------------------------------------------------------------+----------------------------------+-------------+-------------------+----------+------------+---------------+-------+---------+---------+--------------------|
      # | id  | key         | init_sfen                                                     | title                            | description | direction_message | turn_max | folder_key | moves_answers | index | o_count | x_count | ox_rate            |
      # |-----+-------------+---------------------------------------------------------------+----------------------------------+-------------+-------------------+----------+------------+---------------+-------+---------+---------+--------------------|
      # | 515 | l90gNNaUMNw | position sfen 7nl/7k1/9/7pp/6N2/9/9/9/9 b GS2r2b3g3s2n3l16p 1 | f5dfdababd16fa2e82cb7bca5a12ae97 |             |                   |        0 | public     | []            |     0 |         |         |                    |
      # | 513 | ukSH8ogm31f | position sfen 7nl/7k1/9/7pp/6N2/9/9/9/9 b GS2r2b3g3s2n3l16p 1 | 0c7fe232d103b1a6c588800fde09c2ee |             |                   |        0 | public     | []            |     1 |       2 |       1 | 0.6666666666666666 |
      # | 514 | aQSrSXtOvZb | position sfen 7nl/7k1/9/7pp/6N2/9/9/9/9 b GS2r2b3g3s2n3l16p 1 | c7bb020c07001cf36bd8e3efb0941a08 |             |                   |        0 | public     | []            |     2 |       0 |       1 |                0.0 |
      # |-----+-------------+---------------------------------------------------------------+----------------------------------+-------------+-------------------+----------+------------+---------------+-------+---------+---------+--------------------|


      
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

    it "search" do
      Wkbk::Book.destroy_all
      user = User.create!
      book = user.wkbk_books.create!(title: "a", tag_list: "b")
      book = user.wkbk_books.create!(title: "c", tag_list: "d")
      assert { Book.search(query: "a").size === 1 }
      assert { Book.search(query: "a", tag: "b").size === 1 }
    end
  end
end
