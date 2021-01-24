require "./setup"

User.delete_all

Wkbk.destroy_all
Wkbk.setup

################################################################################

Wkbk::Folder.all.collect(&:key) # => []

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
  e.folder_key = :public
end

book # => #<Wkbk::Book id: 7, key: "b3dca3ba8620e3775adfaed39abd7553", user_id: 22, folder_id: 50, title: "アヒル戦法問題集", description: "説明文", created_at: "2021-01-24 04:26:12", updated_at: "2021-01-24 04:26:12", articles_count: 0, user_tag_list: nil, owner_tag_list: nil>

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
# article.update!(folder: article.user.wkbk_private_box) の方法はださい
article.user.wkbk_private_box.articles << article
article.folder # => #<Wkbk::PrivateBox id: 49, user_id: 22, type: "Wkbk::PrivateBox", created_at: "2021-01-24 04:26:12", updated_at: "2021-01-24 04:26:12">

# 2番目の問題は下書きへ
article = Wkbk::Article.second!
article.folder_key           # => "public"
article.folder_key = :private
article.save!                 # => true
article.folder.type           # => ""

tp Wkbk::Article
tp Wkbk.info

# >> |-----+----------------------------------+---------+-----------+------------+---------+--------------------------------------------+----------------+------------------+----------+---------------+-------------+-----------------+-------------------+------------------+---------------------+-----------------+----------+-----------+-------------------+---------------------------+---------------------------+---------------------+----------------------------+---------------+----------------|
# >> | id  | key                              | user_id | folder_id | lineage_id | book_id | init_sfen                                  | time_limit_sec | difficulty_level | title    | description   | hint_desc   | source_author   | source_media_name | source_media_url | source_published_on | source_about_id | turn_max | mate_skip | direction_message | created_at                | updated_at                | moves_answers_count | moves_answer_validate_skip | user_tag_list | owner_tag_list |
# >> |-----+----------------------------------+---------+-----------+------------+---------+--------------------------------------------+----------------+------------------+----------+---------------+-------------+-----------------+-------------------+------------------+---------------------+-----------------+----------+-----------+-------------------+---------------------------+---------------------------+---------------------+----------------------------+---------------+----------------|
# >> | 735 | ec60566301ee36470bd59617bde64b5d |      22 |        49 |         73 |       7 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1  |            180 |                5 | (title0) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-24 13:26:12 +0900 | 2021-01-24 13:26:13 +0900 |                   3 |                            |               |                |
# >> | 736 | 81699ddc64c0624490dbb8e7d8fbabcc |      22 |        49 |         73 |       7 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1  |            180 |                5 | (title1) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-24 13:26:12 +0900 | 2021-01-24 13:26:13 +0900 |                   3 |                            |               |                |
# >> | 737 | 496cdd341567d79a77aff1c8ee2c8ad4 |      22 |        50 |         73 |       7 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1  |            180 |                5 | (title2) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-24 13:26:12 +0900 | 2021-01-24 13:26:12 +0900 |                   3 |                            |               |                |
# >> | 738 | b03eb93efe08dde694da7aaf20ffa21f |      22 |        50 |         73 |       7 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l4p 1  |            180 |                5 | (title3) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-24 13:26:12 +0900 | 2021-01-24 13:26:12 +0900 |                   3 |                            |               |                |
# >> | 739 | 83134b4a40e0fec54217c4c02daa9f21 |      22 |        50 |         73 |       7 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l5p 1  |            180 |                5 | (title4) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-24 13:26:12 +0900 | 2021-01-24 13:26:12 +0900 |                   3 |                            |               |                |
# >> | 740 | 9d3fb77d69b0d24a5e2622d441d1a583 |      22 |        50 |         73 |       7 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l6p 1  |            180 |                5 | (title5) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-24 13:26:13 +0900 | 2021-01-24 13:26:13 +0900 |                   3 |                            |               |                |
# >> | 741 | c781b4bad86325225682113ce50856f3 |      22 |        50 |         73 |       7 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l7p 1  |            180 |                5 | (title6) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-24 13:26:13 +0900 | 2021-01-24 13:26:13 +0900 |                   3 |                            |               |                |
# >> | 742 | f053a80eeae054e7b55acf820120e97d |      22 |        50 |         73 |       7 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l8p 1  |            180 |                5 | (title7) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-24 13:26:13 +0900 | 2021-01-24 13:26:13 +0900 |                   3 |                            |               |                |
# >> | 743 | fe600d4cbb12558c7e85eada641816fb |      22 |        50 |         73 |       7 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l9p 1  |            180 |                5 | (title8) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-24 13:26:13 +0900 | 2021-01-24 13:26:13 +0900 |                   3 |                            |               |                |
# >> | 744 | dea8149414c236b095ac24c5ea1d753f |      22 |        50 |         73 |       7 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l10p 1 |            180 |                5 | (title9) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-24 13:26:13 +0900 | 2021-01-24 13:26:13 +0900 |                   3 |                            |               |                |
# >> |-----+----------------------------------+---------+-----------+------------+---------+--------------------------------------------+----------------+------------------+----------+---------------+-------------+-----------------+-------------------+------------------+---------------------+-----------------+----------+-----------+-------------------+---------------------------+---------------------------+---------------------+----------------------------+---------------+----------------|
# >> |-------------------+-------+--------|
# >> | model             | count | 最終ID |
# >> |-------------------+-------+--------|
# >> | User              |     3 |     24 |
# >> | Wkbk::Article     |    10 |    744 |
# >> | Wkbk::MovesAnswer |    30 |   9382 |
# >> | Wkbk::Folder      |     6 |     54 |
# >> | Wkbk::Lineage     |     8 |     80 |
# >> |-------------------+-------+--------|
