require "./setup"

# tp Actf::Question
# exit

Actf.destroy_all
user = Colosseum::User.sysop
3.times do |i|
  question = user.actf_questions.create! do |e|
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

user2 = Colosseum::User.create!
room = Actf::Room.create! do |e|
  e.memberships.build(user: user)
  e.memberships.build(user: user2)
end
membership = room.memberships.first
Actf::Question.all.each.with_index do |question, i|
  ans_result_key = Actf::AnsResultInfo[i.modulo(Actf::AnsResultInfo.count)].key
  user.actf_histories.create!(membership: membership, question: question, ans_result: Actf::AnsResult.fetch(ans_result_key))
end

# question = Actf::Question.first
# favorite = user.actf_favorites.create!(question: question, score: 1)
# favorite.update!(score: -1)
# favorite.destroy!

tp Actf::Question
# >> |----+---------+-------------------------------------------+----------------+------------------+-------------+---------+---------------+--------------------+---------------+-------------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------+-----------+------------+-----------------+-----------------+-----------------+------------------+-------------|
# >> | id | user_id | init_sfen                                 | time_limit_sec | difficulty_level | display_key | title   | description   | hint_description   | source_desc   | other_twitter_account   | created_at                | updated_at                | moves_answers_count | endpos_answers_count | o_count | x_count | bad_count | good_count | histories_count | favorites_count | bad_marks_count | good_marks_count | clips_count |
# >> |----+---------+-------------------------------------------+----------------+------------------+-------------+---------+---------------+--------------------+---------------+-------------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------+-----------+------------+-----------------+-----------------+-----------------+------------------+-------------|
# >> | 24 |       1 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1 |            180 |                5 | public      | (title) | (description) | (hint_description) | (source_desc) | (other_twitter_account) | 2020-05-17 11:02:44 +0900 | 2020-05-16 11:02:44 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |               0 |                0 |           0 |
# >> | 25 |       1 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1 |            180 |                5 | public      | (title) | (description) | (hint_description) | (source_desc) | (other_twitter_account) | 2020-05-17 11:02:44 +0900 | 2020-05-16 12:02:44 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |               0 |                0 |           0 |
# >> | 26 |       1 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1 |            180 |                5 | public      | (title) | (description) | (hint_description) | (source_desc) | (other_twitter_account) | 2020-05-17 11:02:44 +0900 | 2020-05-16 13:02:44 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |               0 |                0 |           0 |
# >> |----+---------+-------------------------------------------+----------------+------------------+-------------+---------+---------------+--------------------+---------------+-------------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------+-----------+------------+-----------------+-----------------+-----------------+------------------+-------------|
