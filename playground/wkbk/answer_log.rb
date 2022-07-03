#!/usr/bin/env ruby
require "./setup"

user = User.create!
book = user.wkbk_books.create!
book.articles << user.wkbk_articles.create!
book.articles << user.wkbk_articles.create!
book.articles << user.wkbk_articles.create!

correct = ::Wkbk::AnswerKind.fetch("correct")
mistake = ::Wkbk::AnswerKind.fetch("mistake")
answer_log = user.wkbk_answer_logs.create!(article: book.articles[0], answer_kind: correct, book: book)
answer_log = user.wkbk_answer_logs.create!(article: book.articles[0], answer_kind: mistake, book: book)
answer_log = user.wkbk_answer_logs.create!(article: book.articles[1], answer_kind: correct, book: book)
tp user.wkbk_answer_logs

correct_id = ::Wkbk::AnswerKind.fetch("correct").id
mistake_id = ::Wkbk::AnswerKind.fetch("mistake").id
# o_count = "COUNT(answer_kind_id = #{correct_id} OR NULL) AS o_count"
# x_count = "COUNT(answer_kind_id = #{mistake_id} OR NULL) AS x_count"
# select = "article_id, #{o_count}, #{x_count}, MAX(created_at) AS answered_at"
# records = user.wkbk_answer_logs.group("article_id").select(select).order("max(created_at) desc")
# tp records
# 最後の解答 o x を知りたい
# tp user.wkbk_answer_logs.group("article_id").select("article_id").order("max(created_at) desc")
tp user.wkbk_answer_logs.distinct.pluck(:article_id) # => [640, 641]

# tp book.sequenced_articles(user)
# >> |-----+------------+----------------+---------+---------+---------------------------|
# >> | id  | article_id | answer_kind_id | book_id | user_id | created_at                |
# >> |-----+------------+----------------+---------+---------+---------------------------|
# >> | 125 |        640 |              1 |      49 |      46 | 2021-02-14 18:36:29 +0900 |
# >> | 126 |        640 |              2 |      49 |      46 | 2021-02-14 18:36:29 +0900 |
# >> | 127 |        641 |              1 |      49 |      46 | 2021-02-14 18:36:29 +0900 |
# >> |-----+------------+----------------+---------+---------+---------------------------|
# >>    (0.5ms)  SELECT DISTINCT `wkbk_answer_logs`.`article_id` FROM `wkbk_answer_logs` WHERE `wkbk_answer_logs`.`user_id` = 46
# >> |-----|
# >> | 640 |
# >> | 641 |
# >> |-----|
