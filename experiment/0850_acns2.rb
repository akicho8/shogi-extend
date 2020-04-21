#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

Acns2::Question.destroy_all

user = Colosseum::User.create!

question = user.acns2_questions.create! do |e|
  e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1"
  e.moves_answers.build(moves_str: "G*5b")
  e.endpos_answers.build(sfen_endpos: "4k4/4G4/4G4/9/9/9/9/9/9 w 2r2b2g4s4n4l18p 2")
end

# tp question
# tp question.moves_answers
# tp question.endpos_answers

# hash = question.attributes.slice("id", "user_id", "init_sfen", "time_limit_sec")
# hash                            # => {"id"=>7, "user_id"=>16, "init_sfen"=>"4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1", "time_limit_sec"=>nil, "title"=>nil, "description"=>nil, "hint_description"=>nil, "source_desc"=>nil, "other_twitter_account"=>nil, "created_at"=>Mon, 20 Apr 2020 23:02:00 JST +09:00, "updated_at"=>Mon, 20 Apr 2020 23:02:00 JST +09:00, "o_count"=>0, "x_count"=>0}

hash = question.attributes
hash = hash.merge(moves_answers_attributes: question.moves_answers)
tp hash.as_json

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
# >> |--------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                       id | 14                                                                                                                                                                        |
# >> |                  user_id | 23                                                                                                                                                                        |
# >> |                init_sfen | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1                                                                                                                                |
# >> |           time_limit_sec |                                                                                                                                                                           |
# >> |                    title |                                                                                                                                                                           |
# >> |              description |                                                                                                                                                                           |
# >> |         hint_description |                                                                                                                                                                           |
# >> |              source_desc |                                                                                                                                                                           |
# >> |    other_twitter_account |                                                                                                                                                                           |
# >> |               created_at | 2020-04-20T23:13:37.697+09:00                                                                                                                                             |
# >> |               updated_at | 2020-04-20T23:13:37.697+09:00                                                                                                                                             |
# >> |                  o_count | 0                                                                                                                                                                         |
# >> |                  x_count | 0                                                                                                                                                                         |
# >> | moves_answers_attributes | [{"id"=>16, "question_id"=>14, "limit_turn"=>1, "moves_str"=>"G*5b", "created_at"=>"2020-04-20T23:13:37.701+09:00", "updated_at"=>"2020-04-20T23:13:37.701+09:00"}] |
# >> |--------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
