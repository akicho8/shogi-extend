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
      user = User.create!
      book = user.wkbk_books.create!
      book.articles << user.wkbk_articles.create!
      user.wkbk_answer_logs.create!(article: book.articles[0], answer_kind: AnswerKind.fetch("correct"), book: book, spent_sec: 1)
      user.wkbk_answer_logs.create!(article: book.articles[0], answer_kind: AnswerKind.fetch("mistake"), book: book, spent_sec: 1)
    end
  end
end
