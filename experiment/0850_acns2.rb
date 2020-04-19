#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

Acns2::Question.destroy_all

user = Colosseum::User.create!

question = user.acns2_questions.create! do |e|
  e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1"
  e.moves_answers.build(sfen_moves_pack: "G*5b")
  e.endpos_answers.build(sfen_endpos: "4k4/4G4/4G4/9/9/9/9/9/9 w 2r2b2g4s4n4l18p 2")
end
tp question
tp question.moves_answers
tp question.endpos_answers

# Acns2::Room.destroy_all

# user1 = Colosseum::User.create!
# user2 = Colosseum::User.create!
#
# 10.times do
#   Acns2::Room.create! do |e|
#     e.memberships.build(user: user1, judge_key: "win")
#     e.memberships.build(user: user2, judge_key: "lose")
#   end
# end

# tp Acns2::Membership
# >> |-----------------------+--------------------------------------------|
# >> |                    id | 1                                          |
# >> |               user_id | 14                                         |
# >> |             init_sfen | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1 |
# >> |        time_limit_sec |                                            |
# >> |                 title |                                            |
# >> |           description |                                            |
# >> |      hint_description |                                            |
# >> |           source_desc |                                            |
# >> | other_twitter_account |                                            |
# >> |            created_at | 2020-04-19 21:07:35 +0900                  |
# >> |            updated_at | 2020-04-19 21:07:35 +0900                  |
# >> |               o_count | 0                                          |
# >> |               x_count | 0                                          |
# >> |-----------------------+--------------------------------------------|
# >> |----+-------------+------------+-----------------+---------------------------+---------------------------|
# >> | id | question_id | limit_turn | sfen_moves_pack | created_at                | updated_at                |
# >> |----+-------------+------------+-----------------+---------------------------+---------------------------|
# >> |  1 |           1 |          1 | G*5b            | 2020-04-19 21:07:35 +0900 | 2020-04-19 21:07:35 +0900 |
# >> |----+-------------+------------+-----------------+---------------------------+---------------------------|
# >> |----+-------------+------------+---------------------------------------------+---------------------------+---------------------------|
# >> | id | question_id | limit_turn | sfen_endpos                                 | created_at                | updated_at                |
# >> |----+-------------+------------+---------------------------------------------+---------------------------+---------------------------|
# >> |  1 |           1 |          2 | 4k4/4G4/4G4/9/9/9/9/9/9 w 2r2b2g4s4n4l18p 2 | 2020-04-19 21:07:35 +0900 | 2020-04-19 21:07:35 +0900 |
# >> |----+-------------+------------+---------------------------------------------+---------------------------+---------------------------|
