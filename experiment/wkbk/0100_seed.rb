require "./setup"

User.delete_all

Wkbk.destroy_all
Wkbk.setup

################################################################################

Wkbk::Folder.all.collect(&:key) # => ["private", "public"]

Wkbk::Article.count          # => 0
Wkbk::Book.count             # => 0
Wkbk::Lineage.all.collect(&:key) # => ["次の一手", "手筋", "定跡", "必死", "必死逃れ", "実戦詰め筋", "持駒限定詰将棋", "詰将棋"]

user1 = User.sysop
user2 = User.find_or_create_by!(key: "alice")

User.setup

################################################################################

book = user1.wkbk_books.create! do |e|
  e.title = "アヒル戦法問題集"
  e.description = "説明文"
  e.folder_key = :public
end

book # => #<Wkbk::Book id: 4, key: "6b46741375ac52282ecf1cb7ef5adaed", user_id: 12, folder_id: 10, title: "アヒル戦法問題集", description: "説明文", articles_count: 0, created_at: "2021-01-28 05:26:35", updated_at: "2021-01-28 05:26:35">

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

    e.title                 = "(title#{i})"
    e.description           = "(description)"
  end

  book.articles << article
end
Wkbk::Article.count           # => 10
book.articles.count           # => 10

article = Wkbk::Article.first!
article.lineage.key               # => "次の一手"

tp Wkbk::Article
tp Wkbk.info

# >> |----+----------------------------------+---------+------------+---------+--------------------------------------------+-----------+----------+---------------+----------+-----------+-------------------+---------------------+---------------------------+---------------------------+----------------------------+---------------+----------------|
# >> | id | key                              | user_id | lineage_id | book_id | init_sfen                                  | viewpoint | title    | description   | turn_max | mate_skip | direction_message | moves_answers_count | created_at                | updated_at                | moves_answer_validate_skip | user_tag_list | owner_tag_list |
# >> |----+----------------------------------+---------+------------+---------+--------------------------------------------+-----------+----------+---------------+----------+-----------+-------------------+---------------------+---------------------------+---------------------------+----------------------------+---------------+----------------|
# >> | 71 | 1009b8f21b1dd92ac956c9eb3676c196 |      12 |         33 |       4 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1  | black     | (title0) | (description) |        1 |           |                   |                   3 | 2021-01-28 14:26:35 +0900 | 2021-01-28 14:26:35 +0900 |                            |               |                |
# >> | 72 | e2961e8388b97a1cc0c9d264f9317f91 |      12 |         33 |       4 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1  | black     | (title1) | (description) |        1 |           |                   |                   3 | 2021-01-28 14:26:35 +0900 | 2021-01-28 14:26:35 +0900 |                            |               |                |
# >> | 73 | 299920ca31d1a8a0d4ca4cb86037a93e |      12 |         33 |       4 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1  | black     | (title2) | (description) |        1 |           |                   |                   3 | 2021-01-28 14:26:35 +0900 | 2021-01-28 14:26:35 +0900 |                            |               |                |
# >> | 74 | e07fe1d80040bbfd01dc118d77e0410e |      12 |         33 |       4 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l4p 1  | black     | (title3) | (description) |        1 |           |                   |                   3 | 2021-01-28 14:26:35 +0900 | 2021-01-28 14:26:36 +0900 |                            |               |                |
# >> | 75 | 66bbfaae8a772961802b6cac52d49145 |      12 |         33 |       4 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l5p 1  | black     | (title4) | (description) |        1 |           |                   |                   3 | 2021-01-28 14:26:36 +0900 | 2021-01-28 14:26:36 +0900 |                            |               |                |
# >> | 76 | e4cfa7e7ce8c9060b8fd3e69989c1fcc |      12 |         33 |       4 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l6p 1  | black     | (title5) | (description) |        1 |           |                   |                   3 | 2021-01-28 14:26:36 +0900 | 2021-01-28 14:26:36 +0900 |                            |               |                |
# >> | 77 | d6a614c37431104c25bf68aec1b8b118 |      12 |         33 |       4 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l7p 1  | black     | (title6) | (description) |        1 |           |                   |                   3 | 2021-01-28 14:26:36 +0900 | 2021-01-28 14:26:36 +0900 |                            |               |                |
# >> | 78 | 633b406b3a4922faa6773b95d43a1c8a |      12 |         33 |       4 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l8p 1  | black     | (title7) | (description) |        1 |           |                   |                   3 | 2021-01-28 14:26:36 +0900 | 2021-01-28 14:26:36 +0900 |                            |               |                |
# >> | 79 | 80c1052f0b08ea7dfbc64305fbca86d3 |      12 |         33 |       4 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l9p 1  | black     | (title8) | (description) |        1 |           |                   |                   3 | 2021-01-28 14:26:36 +0900 | 2021-01-28 14:26:36 +0900 |                            |               |                |
# >> | 80 | 133afd7bf50f828a94d72ea96963b62e |      12 |         33 |       4 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l10p 1 | black     | (title9) | (description) |        1 |           |                   |                   3 | 2021-01-28 14:26:36 +0900 | 2021-01-28 14:26:36 +0900 |                            |               |                |
# >> |----+----------------------------------+---------+------------+---------+--------------------------------------------+-----------+----------+---------------+----------+-----------+-------------------+---------------------+---------------------------+---------------------------+----------------------------+---------------+----------------|
# >> |-------------------+-------+--------|
# >> | model             | count | 最終ID |
# >> |-------------------+-------+--------|
# >> | User              |     3 |     14 |
# >> | Wkbk::Folder      |     2 |     10 |
# >> | Wkbk::Lineage     |     8 |     40 |
# >> | Wkbk::Book        |     1 |      4 |
# >> | Wkbk::Article     |    10 |     80 |
# >> | Wkbk::MovesAnswer |    30 |    190 |
# >> |-------------------+-------+--------|
