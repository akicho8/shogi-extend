#!/usr/bin/env ruby
require "./setup"

class App
  def current_scope
    @current_scope ||= current_user.wkbk_answer_logs.where(created_at: yesterday_range)
  end

  def yesterday_range
    @yesterday_range ||= Time.current.yesterday.all_day
  end

  def answer_kind_id_group_fetch(book)
    current_scope.where(book: book).group(:answer_kind_id).count
  end

  def current_user
    @current_user ||= User.create!
  end

  def counts_hash
    @counts_hash ||= current_scope.group(:book_id).group(:answer_kind_id).count # => {[119, 1]=>2, [120, 1]=>2, [120, 2]=>1}, {[119, 1]=>2, [120, 1]=>2, [120, 2]=>1}, {[119, 1]=>2, [120, 1]=>2, [120, 2]=>1}, {[119, 1]=>2, [120, 1]=>2, [120, 2]=>1}
  end

  # たくさん解いた問題集順の問題集リスト
  def books
    @books ||= yield_self do
      counts = current_scope.group(:book_id).order(count_all: :desc).count # => {120=>3, 119=>2}
      ids = counts.keys
      Wkbk::Book.where(id: ids).order([Arel.sql("FIELD(id, ?)"), ids])
    end
  end

  def book_report(book)
    o = counts_hash.fetch([book.id, ::Wkbk::AnswerKind.o.id], 0)
    x = counts_hash.fetch([book.id, ::Wkbk::AnswerKind.x.id], 0)
    t = o + x
    r = (o * 100).fdiv(t).truncate
    "正解率 #{r} % (#{o}/#{t})"
  end

  def call
    book = current_user.wkbk_books.create!
    book.articles << current_user.wkbk_articles.create!
    book.articles << current_user.wkbk_articles.create!
    book.articles << current_user.wkbk_articles.create!

    book = current_user.wkbk_books.create!
    book.articles << current_user.wkbk_articles.create!
    book.articles << current_user.wkbk_articles.create!
    book.articles << current_user.wkbk_articles.create!

    Timecop.freeze("2000-01-01 00:00")
    answer_log = current_user.wkbk_answer_logs.create!(article: current_user.wkbk_books[0].articles[0], answer_kind: ::Wkbk::AnswerKind.o, book: current_user.wkbk_books[0])
    answer_log = current_user.wkbk_answer_logs.create!(article: current_user.wkbk_books[0].articles[0], answer_kind: ::Wkbk::AnswerKind.o, book: current_user.wkbk_books[0])
    answer_log = current_user.wkbk_answer_logs.create!(article: current_user.wkbk_books[1].articles[0], answer_kind: ::Wkbk::AnswerKind.o, book: current_user.wkbk_books[1])
    answer_log = current_user.wkbk_answer_logs.create!(article: current_user.wkbk_books[1].articles[0], answer_kind: ::Wkbk::AnswerKind.o, book: current_user.wkbk_books[1])
    answer_log = current_user.wkbk_answer_logs.create!(article: current_user.wkbk_books[1].articles[0], answer_kind: ::Wkbk::AnswerKind.x, book: current_user.wkbk_books[1])
    tp current_user.wkbk_answer_logs
    Timecop.freeze("2000-01-02 00:00")

    current_scope.count                              # => 5

    tp books

    out = books.collect { |book|
      [
        "▼#{book.title}",
        book.page_url,
        book_report(book),
      ].join("\n")
    }.join("\n\n")
    puts out
  end
end

App.new.call
# >> |-----+------------+----------------+---------+---------+-----------+---------------------------|
# >> | id  | article_id | answer_kind_id | book_id | user_id | spent_sec | created_at                |
# >> |-----+------------+----------------+---------+---------+-----------+---------------------------|
# >> | 231 |        852 |              1 |     119 |      66 |         0 | 2000-01-01 00:00:00 +0900 |
# >> | 232 |        852 |              1 |     119 |      66 |         0 | 2000-01-01 00:00:00 +0900 |
# >> | 233 |        855 |              1 |     120 |      66 |         0 | 2000-01-01 00:00:00 +0900 |
# >> | 234 |        855 |              1 |     120 |      66 |         0 | 2000-01-01 00:00:00 +0900 |
# >> | 235 |        855 |              2 |     120 |      66 |         0 | 2000-01-01 00:00:00 +0900 |
# >> |-----+------------+----------------+---------+---------+-----------+---------------------------|
# >> |-----+-------------+---------+-----------+-------------+-------------+---------------+-----------------+-------------------+---------------------------+---------------------------+----------+--------------|
# >> | id  | key         | user_id | folder_id | sequence_id | title       | description   | bookships_count | answer_logs_count | created_at                | updated_at                | tag_list | current_user |
# >> |-----+-------------+---------+-----------+-------------+-------------+---------------+-----------------+-------------------+---------------------------+---------------------------+----------+--------------|
# >> | 120 | p1hjbgnYagI |      66 |         3 |           1 | p1hjbgnYagI | (description) |               3 |                 0 | 2021-02-18 20:54:40 +0900 | 2021-02-18 20:54:40 +0900 |          |              |
# >> | 119 | P4A0b37rg2i |      66 |         3 |           1 | P4A0b37rg2i | (description) |               3 |                 0 | 2021-02-18 20:54:39 +0900 | 2021-02-18 20:54:40 +0900 |          |              |
# >> |-----+-------------+---------+-----------+-------------+-------------+---------------+-----------------+-------------------+---------------------------+---------------------------+----------+--------------|
# >> ▼p1hjbgnYagI
# >> http://localhost:4000/rack/books/p1hjbgnYagI
# >> 正解率 66 % (2/3)
# >>
# >> ▼P4A0b37rg2i
# >> http://localhost:4000/rack/books/P4A0b37rg2i
# >> 正解率 100 % (2/2)
