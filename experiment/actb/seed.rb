require "./setup"

Colosseum::User.delete_all

Actb.destroy_all
Actb.setup

# tp Actb.info

user1 = Colosseum::User.sysop
user2 = Colosseum::User.find_or_create_by!(key: "alice")

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

tp Actb::Question

tp Actb.info
# >> |----+---------+-------------------------------------------+----------------+------------------+-------------+---------+---------------+--------------------+---------------+-------------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------+-----------+------------+-----------------+-----------------+-----------------+------------------+------------------|
# >> | id | user_id | init_sfen                                 | time_limit_sec | difficulty_level | display_key | title   | description   | hint_description   | source_desc   | other_twitter_account   | created_at                | updated_at                | moves_answers_count | endpos_answers_count | o_count | x_count | bad_count | good_count | histories_count | favorites_count | bad_marks_count | good_marks_count | clip_marks_count |
# >> |----+---------+-------------------------------------------+----------------+------------------+-------------+---------+---------------+--------------------+---------------+-------------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------+-----------+------------+-----------------+-----------------+-----------------+------------------+------------------|
# >> |  1 |      13 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1 |            180 |                5 | public      | (title) | (description) | (hint_description) | (source_desc) | (other_twitter_account) | 2020-05-18 12:00:18 +0900 | 2020-05-17 12:00:18 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |               0 |                1 |                0 |
# >> |  2 |      13 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1 |            180 |                5 | public      | (title) | (description) | (hint_description) | (source_desc) | (other_twitter_account) | 2020-05-18 12:00:19 +0900 | 2020-05-17 13:00:18 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |               1 |                0 |                0 |
# >> |  3 |      13 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1 |            180 |                5 | public      | (title) | (description) | (hint_description) | (source_desc) | (other_twitter_account) | 2020-05-18 12:00:19 +0900 | 2020-05-17 14:00:19 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |               0 |                0 |                1 |
# >> |----+---------+-------------------------------------------+----------------+------------------+-------------+---------+---------------+--------------------+---------------+-------------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------+-----------+------------+-----------------+-----------------+-----------------+------------------+------------------|
# >> |-----------------+-------+--------|
# >> | model           | count | 最終ID |
# >> |-----------------+-------+--------|
# >> | Colosseum::User |     2 |     14 |
# >> | Actb::Question  |     3 |      3 |
# >> | Actb::Room      |     1 |      1 |
# >> | Actb::Season    |     1 |      2 |
# >> | Actb::Profile   |     2 |     14 |
# >> | Actb::GoodMark  |     1 |      1 |
# >> | Actb::BadMark   |     1 |      1 |
# >> | Actb::ClipMark  |     1 |      1 |
# >> |-----------------+-------+--------|
