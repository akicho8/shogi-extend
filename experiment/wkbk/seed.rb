require "./setup"

User.delete_all

Wkbk.destroy_all
Wkbk.setup

Wkbk::Question.count             # => 0
Wkbk::Lineage.all.collect(&:key) # => ["詰将棋", "玉方持駒限定詰将棋", "実戦詰め筋", "手筋", "必死", "必死逃れ", "定跡"]

user1 = User.sysop
user2 = User.find_or_create_by!(key: "alice")

User.setup

# 問題作成
10.times do |i|
  question = user1.wkbk_questions.create! do |e|
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
end
Wkbk::Question.count           # => 10

question = Wkbk::Question.first!
question.lineage.key               # => "詰将棋"

# 最初の問題だけゴミ箱へ
question = Wkbk::Question.first!
# question.update!(folder: question.user.wkbk_trash_box) の方法はださい
question.user.wkbk_trash_box.questions << question
question.folder # => #<Wkbk::TrashBox id: 135, user_id: 45, type: "Wkbk::TrashBox", created_at: "2021-01-21 12:46:53", updated_at: "2021-01-21 12:46:53">

# 2番目の問題は下書きへ
question = Wkbk::Question.second!
question.folder_key           # => "active"
question.folder_key = :draft
question.save!                 # => true
question.folder.type           # => "is-warning"

tp Wkbk::Question
tp Wkbk.info
# >> |----+----------------------------------+---------+-----------+------------+--------------------------------------------+----------------+------------------+----------+---------------+-------------+-----------------+-------------------+------------------+---------------------+-----------------+----------+-----------+-------------------+---------------------------+---------------------------+---------------------+----------------------------+---------------+----------------|
# >> | id | key                              | user_id | folder_id | lineage_id | init_sfen                                  | time_limit_sec | difficulty_level | title    | description   | hint_desc   | source_author   | source_media_name | source_media_url | source_published_on | source_about_id | turn_max | mate_skip | direction_message | created_at                | updated_at                | moves_answers_count | moves_answer_validate_skip | user_tag_list | owner_tag_list |
# >> |----+----------------------------------+---------+-----------+------------+--------------------------------------------+----------------+------------------+----------+---------------+-------------+-----------------+-------------------+------------------+---------------------+-----------------+----------+-----------+-------------------+---------------------------+---------------------------+---------------------+----------------------------+---------------+----------------|
# >> | 20 | 50d345f81450b0797a0e729cd124b070 |      45 |       135 |        106 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1  |            180 |                5 | (title0) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-21 21:46:54 +0900 | 2021-01-21 21:46:54 +0900 |                   3 |                            |               |                |
# >> | 21 | 34157148a6df644d71e96fbd76547380 |      45 |       134 |        106 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1  |            180 |                5 | (title1) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-21 21:46:54 +0900 | 2021-01-21 21:46:54 +0900 |                   3 |                            |               |                |
# >> | 22 | 70d61e3284af5307028e9c065f431e6e |      45 |       133 |        106 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1  |            180 |                5 | (title2) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-21 21:46:54 +0900 | 2021-01-21 21:46:54 +0900 |                   3 |                            |               |                |
# >> | 23 | 0ba663b5ef6e01b45075a1f6fa40a151 |      45 |       133 |        106 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l4p 1  |            180 |                5 | (title3) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-21 21:46:54 +0900 | 2021-01-21 21:46:54 +0900 |                   3 |                            |               |                |
# >> | 24 | 5e5f447a824bed4f09ebdf9860cb5fd0 |      45 |       133 |        106 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l5p 1  |            180 |                5 | (title4) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-21 21:46:54 +0900 | 2021-01-21 21:46:54 +0900 |                   3 |                            |               |                |
# >> | 25 | 9b4e9708930b2cfdb9b2ccbe13b4bc3a |      45 |       133 |        106 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l6p 1  |            180 |                5 | (title5) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-21 21:46:54 +0900 | 2021-01-21 21:46:54 +0900 |                   3 |                            |               |                |
# >> | 26 | 568b4b19896bc7149c558015d295a3c6 |      45 |       133 |        106 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l7p 1  |            180 |                5 | (title6) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-21 21:46:54 +0900 | 2021-01-21 21:46:54 +0900 |                   3 |                            |               |                |
# >> | 27 | 86f5d4ac1e41e1e5f3f154d2b7cb948f |      45 |       133 |        106 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l8p 1  |            180 |                5 | (title7) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-21 21:46:54 +0900 | 2021-01-21 21:46:54 +0900 |                   3 |                            |               |                |
# >> | 28 | 6791521a3d53738bc49b53a6f2bd4138 |      45 |       133 |        106 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l9p 1  |            180 |                5 | (title8) | (description) | (hint_desc) |                 |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-21 21:46:54 +0900 | 2021-01-21 21:46:54 +0900 |                   3 |                            |               |                |
# >> | 29 | 433db1a3e4706348c6bb07e53afe2a83 |      45 |       133 |        106 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l10p 1 |            180 |                5 | (title9) | (description) | (hint_desc) | (source_author) |                   |                  |                     |               1 |        1 | false     |                   | 2021-01-21 21:46:54 +0900 | 2021-01-21 21:46:54 +0900 |                   3 |                            |               |                |
# >> |----+----------------------------------+---------+-----------+------------+--------------------------------------------+----------------+------------------+----------+---------------+-------------+-----------------+-------------------+------------------+---------------------+-----------------+----------+-----------+-------------------+---------------------------+---------------------------+---------------------+----------------------------+---------------+----------------|
# >> |-------------------+-------+--------|
# >> | model             | count | 最終ID |
# >> |-------------------+-------+--------|
# >> | User              |     3 |     47 |
# >> | Wkbk::Question    |    10 |     29 |
# >> | Wkbk::MovesAnswer |    30 |     86 |
# >> | Wkbk::Folder      |     9 |    141 |
# >> | Wkbk::Lineage     |     7 |    112 |
# >> |-------------------+-------+--------|
