require "./setup"

tp Colosseum::User.sysop.actf_questions


# Actf.destroy_all
# 
# user = Colosseum::User.sysop
# 
# question = user.actf_questions.create! do |e|
#   e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1"
#   e.moves_answers.build(moves_str: "G*5b")
# end
# 
# user2 = Colosseum::User.create!
# 
# room = Actf::Room.create! do |e|
#   e.memberships.build(user: user)
#   e.memberships.build(user: user2)
# end
# 
# membership = room.memberships.first
# 
# history = user.actf_histories.create!(membership: membership, question: question, ans_result: Actf::AnsResult.fetch(:correct))
# tp history

# >> |----+---------+-------------------------------------------+----------------+------------------+-------------+---------+---------------+--------------------+---------------+-------------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------|
# >> | id | user_id | init_sfen                                 | time_limit_sec | difficulty_level | display_key | title   | description   | hint_description   | source_desc   | other_twitter_account   | created_at                | updated_at                | moves_answers_count | endpos_answers_count | o_count | x_count |
# >> |----+---------+-------------------------------------------+----------------+------------------+-------------+---------+---------------+--------------------+---------------+-------------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------|
# >> |  7 |       1 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1 |            180 |                5 | public      | (title) | (description) | (hint_description) | (source_desc) | (other_twitter_account) | 2020-05-14 20:17:12 +0900 | 2020-05-13 20:17:12 +0900 |                   1 |                    0 |       1 |       0 |
# >> |  8 |       1 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1 |            180 |                5 | public      | (title) | (description) | (hint_description) | (source_desc) | (other_twitter_account) | 2020-05-14 20:17:12 +0900 | 2020-05-13 21:17:12 +0900 |                   1 |                    0 |       4 |       0 |
# >> |  9 |       1 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1 |            180 |                5 | public      | (title) | (description) | (hint_description) | (source_desc) | (other_twitter_account) | 2020-05-14 20:17:12 +0900 | 2020-05-13 22:17:12 +0900 |                   1 |                    0 |       2 |       0 |
# >> |----+---------+-------------------------------------------+----------------+------------------+-------------+---------+---------------+--------------------+---------------+-------------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------|
