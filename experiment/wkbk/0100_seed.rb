require "./setup"

User.delete_all

Wkbk.destroy_all
Wkbk.setup

################################################################################

Wkbk::Article.count          # => 0
Wkbk::Book.count             # => 0
Wkbk::Lineage.all.collect(&:key) # => ["詰将棋", "玉方持駒限定詰将棋", "実戦詰め筋", "手筋", "必死", "必死逃れ", "定跡", "実戦譜"]

user1 = User.sysop
user2 = User.find_or_create_by!(key: "alice")

User.setup

################################################################################

book = user1.wkbk_books.create! do |e|
  e.title = "アヒル戦法問題集"
  e.description = "説明文"
  e.folder_key = :active
end

book # => #<Wkbk::Book id: 3, key: "ba22548c3d6ca954ffee75f90a1d98bb", user_id: 9, folder_id: 25, title: "アヒル戦法問題集", description: "説明文", created_at: "2021-01-23 13:05:58", updated_at: "2021-01-23 13:05:58", articles_count: 0, user_tag_list: nil, owner_tag_list: nil>

################################################################################

# 問題作成
10.times do |i|
  article = user1.wkbk_articles.create! do |e|
    e.moves_answer_validate_skip = true

    e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l#{i+1}p 1"
    e.moves_answers.build(moves_str: "G*4b")
    e.moves_answers.build(moves_str: "G*5b")
    e.moves_answers.build(moves_str: "G*6b")

    e.updated_at = Time.current - 1.days + i.hours

    e.time_limit_sec        = 60 * 3
    e.difficulty_level      = 5
    e.title                 = "(title#{i})"
    e.description           = "(description)"
    e.hint_desc             = "(hint_desc)"
    if i.odd?
      e.source_author        = "(source_author)"
    end
  end

  book.articles << article
end
Wkbk::Article.count           # => 10
book.articles.count           # => 10

article = Wkbk::Article.first!
article.lineage.key               # => "詰将棋"

# 最初の問題だけゴミ箱へ
article = Wkbk::Article.first!
# article.update!(folder: article.user.wkbk_trash_box) の方法はださい
article.user.wkbk_trash_box.articles << article
article.folder # => #<Wkbk::TrashBox id: 27, user_id: 9, type: "Wkbk::TrashBox", created_at: "2021-01-23 13:05:57", updated_at: "2021-01-23 13:05:57">

# 2番目の問題は下書きへ
article = Wkbk::Article.second!
article.folder_key           # => "active"
article.folder_key = :draft
article.save!                 # => true
article.folder.type           # => "is-warning"

tp Wkbk::Article
tp Wkbk.info

# >> |----+----------------------------------+---------+-----------+------------+---------+--------------------------------------------+----------------+------------------+----------+---------------+-------------+-----------------+-------------------+------------------+---------------------+-----------------+----------+-----------+-------------------+---------------------------+---------------------------+---------------------+----------------------------+---------------+----------------|
# >> | id | key                              | user_id | folder_id | lineage_id | book_id | init_sfen                                  | time_limit_sec | difficulty_level | title    | description   | hint_desc   | source_author   | source_media_name | source_media_url | source_published_on | source_about_id | turn_max | mate_skip | direction_message | created_at                | updated_at                | moves_answers_count | moves_answer_validate_skip | user_tag_list | owner_tag_list |
# >> |----+----------------------------------+---------+-----------+------------+---------+--------------------------------------------+----------------+------------------+----------+---------------+-------------+-----------------+-------------------+------------------+---------------------+-----------------+----------+-----------+-------------------+---------------------------+---------------------------+---------------------+----------------------------+---------------+----------------|
# >> | 22 | 70e4ac070a2395637b3bc449b8f80a40 |       9 |        27 |         25 |       3 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1  |            180 |                5 | (title0) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-23 22:05:58 +0900 | 2021-01-23 22:05:58 +0900 |                   3 |                            |               |                |
# >> | 23 | cc7a2c9c8a1bce54a80781a42c99f89b |       9 |        26 |         25 |       3 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1  |            180 |                5 | (title1) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-23 22:05:58 +0900 | 2021-01-23 22:05:58 +0900 |                   3 |                            |               |                |
# >> | 24 | f07e9f2ee040af10c811a9f006900f48 |       9 |        25 |         25 |       3 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1  |            180 |                5 | (title2) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-23 22:05:58 +0900 | 2021-01-23 22:05:58 +0900 |                   3 |                            |               |                |
# >> | 25 | 18eb1e9b6d2323ddfb0a169943b67281 |       9 |        25 |         25 |       3 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l4p 1  |            180 |                5 | (title3) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-23 22:05:58 +0900 | 2021-01-23 22:05:58 +0900 |                   3 |                            |               |                |
# >> | 26 | fde78db48f90edfbc79036e0821f56bb |       9 |        25 |         25 |       3 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l5p 1  |            180 |                5 | (title4) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-23 22:05:58 +0900 | 2021-01-23 22:05:58 +0900 |                   3 |                            |               |                |
# >> | 27 | 1179be83a2daa741cef70ec671d4df9c |       9 |        25 |         25 |       3 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l6p 1  |            180 |                5 | (title5) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-23 22:05:58 +0900 | 2021-01-23 22:05:58 +0900 |                   3 |                            |               |                |
# >> | 28 | 8f563de89dca1f27ac4cbbbea02ee89c |       9 |        25 |         25 |       3 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l7p 1  |            180 |                5 | (title6) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-23 22:05:58 +0900 | 2021-01-23 22:05:58 +0900 |                   3 |                            |               |                |
# >> | 29 | df49e1ae3ac9b8e48afa5c4b054681c5 |       9 |        25 |         25 |       3 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l8p 1  |            180 |                5 | (title7) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-23 22:05:58 +0900 | 2021-01-23 22:05:58 +0900 |                   3 |                            |               |                |
# >> | 30 | f6070a5c3e63ebd1a2a64a001dc56ecb |       9 |        25 |         25 |       3 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l9p 1  |            180 |                5 | (title8) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-23 22:05:58 +0900 | 2021-01-23 22:05:58 +0900 |                   3 |                            |               |                |
# >> | 31 | ee7ed77cfece0ad7af5e822a1a40d386 |       9 |        25 |         25 |       3 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l10p 1 |            180 |                5 | (title9) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-23 22:05:58 +0900 | 2021-01-23 22:05:58 +0900 |                   3 |                            |               |                |
# >> |----+----------------------------------+---------+-----------+------------+---------+--------------------------------------------+----------------+------------------+----------+---------------+-------------+-----------------+-------------------+------------------+---------------------+-----------------+----------+-----------+-------------------+---------------------------+---------------------------+---------------------+----------------------------+---------------+----------------|
# >> |-------------------+-------+--------|
# >> | model             | count | 最終ID |
# >> |-------------------+-------+--------|
# >> | User              |     3 |     11 |
# >> | Wkbk::Article     |    10 |     31 |
# >> | Wkbk::MovesAnswer |    30 |     92 |
# >> | Wkbk::Folder      |     9 |     33 |
# >> | Wkbk::Lineage     |     8 |     32 |
# >> |-------------------+-------+--------|
