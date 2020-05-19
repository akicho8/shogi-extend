require "./setup"

Colosseum::User.delete_all

Actb.destroy_all
Actb.setup

10.times do
  Actb::Season.create!
end

# tp Actb.info

user1 = Colosseum::User.sysop
user2 = Colosseum::User.find_or_create_by!(key: "alice")

Colosseum::User.setup
# 8.times do |e|
#   Colosseum::User.create!
# end

# 問題作成
3.times do |i|
  question = user1.actb_questions.create! do |e|
    e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l#{i+1}p 1"
    e.moves_answers.build(moves_str: "G*4b")
    e.moves_answers.build(moves_str: "G*5b")
    e.moves_answers.build(moves_str: "G*6b")

    e.updated_at = Time.current - 1.days + i.hours

    e.time_limit_sec        = 60 * 3
    e.difficulty_level      = 5
    e.title                 = "(title)"
    e.description           = "(description)"
    e.hint_description      = "(hint_description)"
    e.source_desc           = "(source_desc)"
    e.other_twitter_account = "(other_twitter_account)"
  end
end
Actb::Question.count           # => 3

# 部屋を立てる
room = Actb::Room.create! do |e|
  e.memberships.build(user: user1)
  e.memberships.build(user: user2)
end
membership = room.memberships.first

# すべての問題に解答する
Actb::Question.all.each.with_index do |question, i|
  ans_result_key = Actb::AnsResultInfo[i.modulo(Actb::AnsResultInfo.count)].key
  user1.actb_histories.create!(membership: membership, question: question, ans_result: Actb::AnsResult.fetch(ans_result_key))
end

# Good, Bad, Clip
user1.actb_good_marks.create!(question: Actb::Question.first!)
user1.actb_bad_marks.create!(question: Actb::Question.second!)
user1.actb_clip_marks.create!(question: Actb::Question.third!)

# ゴミ箱へ
question = Actb::Question.first!
# question.update!(folder: question.user.actb_trash_box) の方法はださい
question.user.actb_trash_box.questions << question
question.folder # => #<Actb::TrashBox id: 435, user_id: 145, type: "Actb::TrashBox", created_at: "2020-05-19 07:30:18", updated_at: "2020-05-19 07:30:18">

tp Actb::Question

tp Actb.info
# >> |----+---------+-----------+-------------------------------------------+----------------+------------------+-------------+---------+---------------+--------------------+---------------+-------------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------+-----------+------------+-----------------+-----------------+-----------------+------------------+------------------|
# >> | id | user_id | folder_id | init_sfen                                 | time_limit_sec | difficulty_level | display_key | title   | description   | hint_description   | source_desc   | other_twitter_account   | created_at                | updated_at                | moves_answers_count | endpos_answers_count | o_count | x_count | bad_count | good_count | histories_count | favorites_count | bad_marks_count | good_marks_count | clip_marks_count |
# >> |----+---------+-----------+-------------------------------------------+----------------+------------------+-------------+---------+---------------+--------------------+---------------+-------------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------+-----------+------------+-----------------+-----------------+-----------------+------------------+------------------|
# >> | 22 |     145 |       435 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1 |            180 |                5 | public      | (title) | (description) | (hint_description) | (source_desc) | (other_twitter_account) | 2020-05-19 16:30:20 +0900 | 2020-05-19 16:30:20 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |               0 |                1 |                0 |
# >> | 23 |     145 |       433 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1 |            180 |                5 | public      | (title) | (description) | (hint_description) | (source_desc) | (other_twitter_account) | 2020-05-19 16:30:20 +0900 | 2020-05-18 17:30:20 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |               1 |                0 |                0 |
# >> | 24 |     145 |       433 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1 |            180 |                5 | public      | (title) | (description) | (hint_description) | (source_desc) | (other_twitter_account) | 2020-05-19 16:30:20 +0900 | 2020-05-18 18:30:20 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |               0 |                0 |                1 |
# >> |----+---------+-----------+-------------------------------------------+----------------+------------------+-------------+---------+---------------+--------------------+---------------+-------------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------+-----------+------------+-----------------+-----------------+-----------------+------------------+------------------|
# >> |-----------------+-------+--------|
# >> | model           | count | 最終ID |
# >> |-----------------+-------+--------|
# >> | Colosseum::User |    13 |    157 |
# >> | Actb::Question  |     3 |     24 |
# >> | Actb::Room      |     1 |      8 |
# >> | Actb::Season    |    11 |    126 |
# >> | Actb::Profile   |    13 |    159 |
# >> | Actb::GoodMark  |     1 |      8 |
# >> | Actb::BadMark   |     1 |      8 |
# >> | Actb::ClipMark  |     1 |      6 |
# >> | Actb::Folder    |    39 |    471 |
# >> |-----------------+-------+--------|
