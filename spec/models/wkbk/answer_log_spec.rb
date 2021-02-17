# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Answer log (wkbk_answer_logs as Wkbk::AnswerLog)
#
# |----------------+-------------+------------+-------------+--------------+-------|
# | name           | desc        | type       | opts        | refs         | index |
# |----------------+-------------+------------+-------------+--------------+-------|
# | id             | ID          | integer(8) | NOT NULL PK |              |       |
# | article_id     | Article     | integer(8) | NOT NULL    |              | A     |
# | answer_kind_id | Answer kind | integer(8) | NOT NULL    |              | B     |
# | book_id        | Book        | integer(8) | NOT NULL    |              | C     |
# | user_id        | User        | integer(8) | NOT NULL    | => ::User#id | D     |
# | spent_sec      | Spent sec   | integer(4) | NOT NULL    |              | E     |
# | created_at     | 作成日時    | datetime   | NOT NULL    |              | F     |
# |----------------+-------------+------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require 'rails_helper'

module Wkbk
  RSpec.describe AnswerLog, type: :model do
    include WkbkSupportMethods
    include ActiveJob::TestHelper # for perform_enqueued_jobs

    it "works" do
      # user = User.create!
      # book = user.wkbk_books.create!
      # book.articles << user.wkbk_articles.create!(key: "a")
      # book.articles << user.wkbk_articles.create!(key: "b")
      # book.articles << user.wkbk_articles.create!(key: "c")
      #
      # answer_kind = ::Wkbk::AnswerKind.fetch("correct")
      # answer_log = user.wkbk_answer_logs.create!(article: book.articles[0], answer_kind: answer_kind, book: book)
      # answer_log = user.wkbk_answer_logs.create!(article: book.articles[0], answer_kind: answer_kind, book: book)
      # answer_log = user.wkbk_answer_logs.create!(article: book.articles[1], answer_kind: answer_kind, book: book)
      #
      # tp user.wkbk_answer_logs
      #
      # correct_id = ::Wkbk::AnswerKind.fetch("correct").id
      # mistake_id = ::Wkbk::AnswerKind.fetch("mistake").id
      #
      # # hash = s.joins(:grade).group("swars_grades.key").group("judge_key").count # => {["九段", "lose"]=>2, ["九段", "win"]=>1}
      # o_count = "COUNT(answer_kind_id = #{correct_id} OR NULL) AS o_count"
      # x_count = "COUNT(answer_kind_id = #{mistake_id} OR NULL) AS x_count"
      # select = "article_id, #{o_count}, #{x_count}, MAX(created_at) AS created_at"
      # records = user.wkbk_answer_logs.where(book: book).group("article_id").select(select).order("max(created_at) desc")
      #
      # records.collect { |e|
      # }

      # |----+------------+---------------------------+---------+---------|
      # | id | article_id | created_at                | o_count | x_count |
      # |----+------------+---------------------------+---------+---------|
      # |    |        476 | 2000-01-01 00:00:00 +0900 |       2 |       0 |
      # |    |        477 | 2000-01-01 00:00:00 +0900 |       1 |       0 |
      # |----+------------+---------------------------+---------+---------|

    end
  end
end
