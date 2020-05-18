require "./setup"

Colosseum::User.delete_all

Actf.destroy_all
Actf.setup

# tp Actf.info

user1 = Colosseum::User.sysop
user2 = Colosseum::User.find_or_create_by!(key: "alice")

# 問題作成
3.times do |i|
  question = user1.actf_questions.create! do |e|
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
Actf::Question.count           # => 3

# 部屋を立てる
room = Actf::Room.create! do |e|
  e.memberships.build(user: user1)
  e.memberships.build(user: user2)
end
membership = room.memberships.first

# すべての問題に解答する
Actf::Question.all.each.with_index do |question, i|
  ans_result_key = Actf::AnsResultInfo[i.modulo(Actf::AnsResultInfo.count)].key
  user1.actf_histories.create!(membership: membership, question: question, ans_result: Actf::AnsResult.fetch(ans_result_key))
end

# Good, Bad, Clip
user1.actf_good_marks.create!(question: Actf::Question.first!)
user1.actf_bad_marks.create!(question: Actf::Question.second!)
user1.actf_clip_marks.create!(question: Actf::Question.third!)

tp Actf::Question

tp Actf.info
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
# >> | Actf::Question  |     3 |      3 |
# >> | Actf::Room      |     1 |      1 |
# >> | Actf::Season    |     1 |      2 |
# >> | Actf::Profile   |     2 |     14 |
# >> | Actf::GoodMark  |     1 |      1 |
# >> | Actf::BadMark   |     1 |      1 |
# >> | Actf::ClipMark  |     1 |      1 |
# >> |-----------------+-------+--------|
