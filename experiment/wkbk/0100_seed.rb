require "./setup"

User.delete_all

Wkbk.destroy_all
Wkbk.setup

################################################################################

Wkbk::Folder.all.collect(&:key) # => []

Wkbk::Article.count          # => 0
Wkbk::Book.count             # => 0
Wkbk::Lineage.all.collect(&:key) # => ["次の一手", "手筋", "必死", "必死逃れ", "定跡", "詰将棋", "持駒限定詰将棋", "実戦詰め筋"]

user1 = User.sysop
user2 = User.find_or_create_by!(key: "alice")

User.setup

################################################################################

book = user1.wkbk_books.create! do |e|
  e.title = "アヒル戦法問題集"
  e.description = "説明文"
  e.folder_key = :public
end

book # => #<Wkbk::Book id: 4, key: "406536605557b412b93cf189da605a3b", user_id: 14, folder_id: 20, title: "アヒル戦法問題集", description: "説明文", articles_count: 0, created_at: "2021-01-26 02:40:19", updated_at: "2021-01-26 02:40:19", user_tag_list: nil, owner_tag_list: nil>

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
article.folder # => #<Wkbk::PrivateBox id: 19, user_id: 14, type: "Wkbk::PrivateBox", created_at: "2021-01-26 02:40:18", updated_at: "2021-01-26 02:40:18">

# 2番目の問題は下書きへ
article = Wkbk::Article.second!
article.folder_key           # => :public
article.folder_key = :private
article.save!                 # => true
# article.folder.type           # => 

tp Wkbk::Article
tp Wkbk.info

# >> |-----+----------------------------------+---------+-----------+------------+---------+--------------------------------------------+----------------+------------------+----------+---------------+-------------+-----------------+-------------------+------------------+---------------------+-----------------+----------+-----------+-------------------+---------------------------+---------------------------+---------------------+----------------------------+---------------+----------------|
# >> | id  | key                              | user_id | folder_id | lineage_id | book_id | init_sfen                                  | time_limit_sec | difficulty_level | title    | description   | hint_desc   | source_author   | source_media_name | source_media_url | source_published_on | source_about_id | turn_max | mate_skip | direction_message | created_at                | updated_at                | moves_answers_count | moves_answer_validate_skip | user_tag_list | owner_tag_list |
# >> |-----+----------------------------------+---------+-----------+------------+---------+--------------------------------------------+----------------+------------------+----------+---------------+-------------+-----------------+-------------------+------------------+---------------------+-----------------+----------+-----------+-------------------+---------------------------+---------------------------+---------------------+----------------------------+---------------+----------------|
# >> | 221 | 0f22ccbc430949816f4cd39a59275bcc |      14 |        19 |         30 |       4 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1  |            180 |                5 | (title0) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-26 11:40:19 +0900 | 2021-01-26 11:40:20 +0900 |                   3 |                            |               |                |
# >> | 222 | 3d3dfa4ef8967da97c278e9c74b4790d |      14 |        19 |         30 |       4 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1  |            180 |                5 | (title1) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-26 11:40:19 +0900 | 2021-01-26 11:40:20 +0900 |                   3 |                            |               |                |
# >> | 223 | 1209098e83b99774f9a6166ea94d591b |      14 |        20 |         30 |       4 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1  |            180 |                5 | (title2) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-26 11:40:19 +0900 | 2021-01-26 11:40:19 +0900 |                   3 |                            |               |                |
# >> | 224 | 177eb0a8b4d04ebed2e6f8a34fe8d172 |      14 |        20 |         30 |       4 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l4p 1  |            180 |                5 | (title3) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-26 11:40:19 +0900 | 2021-01-26 11:40:19 +0900 |                   3 |                            |               |                |
# >> | 225 | ba22acfc63712c4ed3aadc7bc90b24a4 |      14 |        20 |         30 |       4 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l5p 1  |            180 |                5 | (title4) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-26 11:40:19 +0900 | 2021-01-26 11:40:19 +0900 |                   3 |                            |               |                |
# >> | 226 | 993e9249227a9ed381bb1d09628755cf |      14 |        20 |         30 |       4 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l6p 1  |            180 |                5 | (title5) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-26 11:40:19 +0900 | 2021-01-26 11:40:19 +0900 |                   3 |                            |               |                |
# >> | 227 | 6396dfca871e4fbd32dff81b58d663e6 |      14 |        20 |         30 |       4 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l7p 1  |            180 |                5 | (title6) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-26 11:40:19 +0900 | 2021-01-26 11:40:19 +0900 |                   3 |                            |               |                |
# >> | 228 | 074688f7a35d4813af54cb806182d246 |      14 |        20 |         30 |       4 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l8p 1  |            180 |                5 | (title7) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-26 11:40:19 +0900 | 2021-01-26 11:40:19 +0900 |                   3 |                            |               |                |
# >> | 229 | 0d1bd348a7ef32f8ffb56f20cf382685 |      14 |        20 |         30 |       4 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l9p 1  |            180 |                5 | (title8) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-26 11:40:19 +0900 | 2021-01-26 11:40:19 +0900 |                   3 |                            |               |                |
# >> | 230 | 4d5609c7f7779127ab61914d1a510cec |      14 |        20 |         30 |       4 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l10p 1 |            180 |                5 | (title9) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-26 11:40:19 +0900 | 2021-01-26 11:40:20 +0900 |                   3 |                            |               |                |
# >> |-----+----------------------------------+---------+-----------+------------+---------+--------------------------------------------+----------------+------------------+----------+---------------+-------------+-----------------+-------------------+------------------+---------------------+-----------------+----------+-----------+-------------------+---------------------------+---------------------------+---------------------+----------------------------+---------------+----------------|
# >> |-------------------+-------+--------|
# >> | model             | count | 最終ID |
# >> |-------------------+-------+--------|
# >> | User              |     3 |     16 |
# >> | Wkbk::Article     |    10 |    230 |
# >> | Wkbk::MovesAnswer |    30 |    511 |
# >> | Wkbk::Folder      |     6 |     24 |
# >> | Wkbk::Lineage     |     8 |     32 |
# >> |-------------------+-------+--------|
