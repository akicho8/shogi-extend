require "./setup"
Actf.destroy_all
user = Colosseum::User.sysop
3.times do |i|
  question = user.actf_questions.create! do |e|
    e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l#{i+1}p 1"
    e.moves_answers.build(moves_str: "G*5b")
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

tp Actf::Question
# >> |----+---------+-------------------------------------------+----------------+------------------+-------------+---------+---------------+--------------------+---------------+-------------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------|
# >> | id | user_id | init_sfen                                 | time_limit_sec | difficulty_level | display_key | title   | description   | hint_description   | source_desc   | other_twitter_account   | created_at                | updated_at                | moves_answers_count | endpos_answers_count | o_count | x_count |
# >> |----+---------+-------------------------------------------+----------------+------------------+-------------+---------+---------------+--------------------+---------------+-------------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------|
# >> |  7 |       1 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1 |            180 |                5 | public      | (title) | (description) | (hint_description) | (source_desc) | (other_twitter_account) | 2020-05-14 20:17:12 +0900 | 2020-05-13 20:17:12 +0900 |                   1 |                    0 |       0 |       0 |
# >> |  8 |       1 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1 |            180 |                5 | public      | (title) | (description) | (hint_description) | (source_desc) | (other_twitter_account) | 2020-05-14 20:17:12 +0900 | 2020-05-13 21:17:12 +0900 |                   1 |                    0 |       0 |       0 |
# >> |  9 |       1 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1 |            180 |                5 | public      | (title) | (description) | (hint_description) | (source_desc) | (other_twitter_account) | 2020-05-14 20:17:12 +0900 | 2020-05-13 22:17:12 +0900 |                   1 |                    0 |       0 |       0 |
# >> |----+---------+-------------------------------------------+----------------+------------------+-------------+---------+---------------+--------------------+---------------+-------------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------|
