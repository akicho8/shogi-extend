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

book # => #<Wkbk::Book id: 2, key: "52fdc1c0b86cb9e2c12099055c81bfc9", user_id: 6, folder_id: 16, title: "アヒル戦法問題集", description: "説明文", created_at: "2021-01-22 04:51:12", updated_at: "2021-01-22 04:51:12", articles_count: 0, user_tag_list: nil, owner_tag_list: nil>

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
article.folder # => #<Wkbk::TrashBox id: 18, user_id: 6, type: "Wkbk::TrashBox", created_at: "2021-01-22 04:51:11", updated_at: "2021-01-22 04:51:11">

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
# >> | 12 | f96d0ff8f13c621bb9cf69a4caa5b754 |       6 |        18 |         17 |       2 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1  |            180 |                5 | (title0) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-22 13:51:12 +0900 | 2021-01-22 13:51:13 +0900 |                   3 |                            |               |                |
# >> | 13 | 46d09880432b9fb46b1934793ce5809d |       6 |        17 |         17 |       2 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1  |            180 |                5 | (title1) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-22 13:51:12 +0900 | 2021-01-22 13:51:13 +0900 |                   3 |                            |               |                |
# >> | 14 | e8e939e8ddf0cecc621051c3bc488c12 |       6 |        16 |         17 |       2 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1  |            180 |                5 | (title2) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-22 13:51:12 +0900 | 2021-01-22 13:51:12 +0900 |                   3 |                            |               |                |
# >> | 15 | 4bd0fbd146681572ed24fe64d3556687 |       6 |        16 |         17 |       2 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l4p 1  |            180 |                5 | (title3) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-22 13:51:12 +0900 | 2021-01-22 13:51:12 +0900 |                   3 |                            |               |                |
# >> | 16 | 49818716382be5a687ae46121573abbb |       6 |        16 |         17 |       2 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l5p 1  |            180 |                5 | (title4) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-22 13:51:12 +0900 | 2021-01-22 13:51:12 +0900 |                   3 |                            |               |                |
# >> | 17 | b464a2b34b4a3c9109f1d3b8c94ff5ed |       6 |        16 |         17 |       2 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l6p 1  |            180 |                5 | (title5) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-22 13:51:12 +0900 | 2021-01-22 13:51:12 +0900 |                   3 |                            |               |                |
# >> | 18 | a211980f70ddff243956abd1e32bfab0 |       6 |        16 |         17 |       2 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l7p 1  |            180 |                5 | (title6) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-22 13:51:12 +0900 | 2021-01-22 13:51:12 +0900 |                   3 |                            |               |                |
# >> | 19 | 6f68dc272f6b67cba797295eae13f3a1 |       6 |        16 |         17 |       2 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l8p 1  |            180 |                5 | (title7) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-22 13:51:12 +0900 | 2021-01-22 13:51:12 +0900 |                   3 |                            |               |                |
# >> | 20 | fb9aad52c96adff94bee742668ad5a25 |       6 |        16 |         17 |       2 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l9p 1  |            180 |                5 | (title8) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-22 13:51:12 +0900 | 2021-01-22 13:51:13 +0900 |                   3 |                            |               |                |
# >> | 21 | ab75ab829d17bf4f06f851249d12c980 |       6 |        16 |         17 |       2 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l10p 1 |            180 |                5 | (title9) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-22 13:51:13 +0900 | 2021-01-22 13:51:13 +0900 |                   3 |                            |               |                |
# >> |----+----------------------------------+---------+-----------+------------+---------+--------------------------------------------+----------------+------------------+----------+---------------+-------------+-----------------+-------------------+------------------+---------------------+-----------------+----------+-----------+-------------------+---------------------------+---------------------------+---------------------+----------------------------+---------------+----------------|
# >> |-------------------+-------+--------|
# >> | model             | count | 最終ID |
# >> |-------------------+-------+--------|
# >> | User              |     3 |      8 |
# >> | Wkbk::Article     |    10 |     21 |
# >> | Wkbk::MovesAnswer |    30 |     62 |
# >> | Wkbk::Folder      |     9 |     24 |
# >> | Wkbk::Lineage     |     8 |     24 |
# >> |-------------------+-------+--------|
