require 'rails_helper'

module Wkbk
  RSpec.describe XitemsBuilder, type: :model do
    include WkbkSupportMethods
    include ActiveJob::TestHelper # for perform_enqueued_jobs

    it "正誤情報を付与した to_xitems" do
      user = User.create!
      book = user.wkbk_books.create!
      book.articles << user.wkbk_articles.create! # 0 o:2 x:1
      book.articles << user.wkbk_articles.create! # 1 o:0 x:1
      book.articles << user.wkbk_articles.create! # 2 o:0 x:0

      answer_log = user.wkbk_answer_logs.create!(article: book.articles[0], answer_kind: AnswerKind.o, book: book)
      answer_log = user.wkbk_answer_logs.create!(article: book.articles[0], answer_kind: AnswerKind.o, book: book)
      answer_log = user.wkbk_answer_logs.create!(article: book.articles[0], answer_kind: AnswerKind.x, book: book)
      answer_log = user.wkbk_answer_logs.create!(article: book.articles[1], answer_kind: AnswerKind.x, book: book)

      xitems_builder = XitemsBuilder.new(current_user: user, book: book)
      tp xitems_builder.answer_log_stat
      # |----+------------+---------------+---------------+-----------------+---------------------|
      # | id | article_id | correct_count | mistake_count | spent_sec_total | last_answered_at    |
      # |----+------------+---------------+---------------+-----------------+---------------------|
      # |    |         63 |             2 |             1 |               0 | 2000-01-01 00:00:00 |
      # |    |         64 |             0 |             1 |               0 | 2000-01-01 00:00:00 |
      # |----+------------+---------------+---------------+-----------------+---------------------|
    end
  end
end
