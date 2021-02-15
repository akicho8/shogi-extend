require 'rails_helper'

module Wkbk
  RSpec.describe XitemsBuilder, type: :model do
    include WkbkSupportMethods
    include ActiveJob::TestHelper # for perform_enqueued_jobs

    it "works" do
      user = User.create!
      book = user.wkbk_books.create!
      book.articles << user.wkbk_articles.create! # 0 o:2 x:1
      book.articles << user.wkbk_articles.create! # 1 o:0 x:1
      book.articles << user.wkbk_articles.create! # 2 o:0 x:0

      user.wkbk_answer_logs.create!(article: book.articles[0], answer_kind: AnswerKind.o, book: book, spent_sec: 0)
      user.wkbk_answer_logs.create!(article: book.articles[0], answer_kind: AnswerKind.o, book: book, spent_sec: 1)
      user.wkbk_answer_logs.create!(article: book.articles[0], answer_kind: AnswerKind.x, book: book, spent_sec: 2)
      user.wkbk_answer_logs.create!(article: book.articles[1], answer_kind: AnswerKind.x, book: book, spent_sec: 61)

      xitems_builder = XitemsBuilder.new(current_user: user, book: book)
      records = xitems_builder.answer_log_stat_records
      assert { records[0].correct_count == 2 }
      assert { records[0].spent_sec_total == 3 }

      # tp records
      # |----+------------+---------------+---------------+-----------------+---------------------|
      # | id | article_id | correct_count | mistake_count | spent_sec_total | last_answered_at    |
      # |----+------------+---------------+---------------+-----------------+---------------------|
      # |    |         76 |             2 |             1 |               3 | 2000-01-01 00:00:00 |
      # |    |         77 |             0 |             1 |              61 | 2000-01-01 00:00:00 |
      # |----+------------+---------------+---------------+-----------------+---------------------|
    end
  end
end
