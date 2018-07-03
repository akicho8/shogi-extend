#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

module Fanta
  User.destroy_all
  Battle.destroy_all

  user1 = User.create!(platoon_key: :platoon_p2vs2)
  user2 = User.create!(platoon_key: :platoon_p2vs2)
  user3 = User.create!(race_key: :robot)

  user1.matching_start
  battle = user2.matching_start

  tp battle
  tp battle.memberships
  tp User
end
# >> I, [2018-07-03T18:10:08.652403 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (1925.13ms)
# >> I, [2018-07-03T18:10:08.670708 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (3.32ms)
# >> I, [2018-07-03T18:10:08.723109 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.44ms)
# >> I, [2018-07-03T18:10:08.749352 #69202]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (1.63ms)
# >> I, [2018-07-03T18:10:08.755352 #69202]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.79ms)
# >> I, [2018-07-03T18:10:08.770937 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.98ms)
# >> I, [2018-07-03T18:10:08.785608 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (5.11ms)
# >> I, [2018-07-03T18:10:08.800124 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.76ms)
# >> I, [2018-07-03T18:10:08.807485 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (2.83ms)
# >> ["/Users/ikeda/src/shogi_web/app/models/fanta/user.rb:298", :matching_start, ["野良1号"]]
# >> 3
# >> I, [2018-07-03T18:10:08.833381 #69202]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (2.45ms)
# >> I, [2018-07-03T18:10:08.837013 #69202]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.86ms)
# >> I, [2018-07-03T18:10:08.845042 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.18ms)
# >> I, [2018-07-03T18:10:08.851749 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.27ms)
# >> I, [2018-07-03T18:10:08.856485 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (2.54ms)
# >> I, [2018-07-03T18:10:08.861486 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (2.65ms)
# >> I, [2018-07-03T18:10:08.902450 #69202]  INFO -- : Rendered Fanta::ChatMessageSerializer with ActiveModelSerializers::Adapter::Attributes (0.98ms)
# >> I, [2018-07-03T18:10:08.908871 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (3.13ms)
# >> I, [2018-07-03T18:10:08.923822 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.98ms)
# >> I, [2018-07-03T18:10:08.936581 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (5.44ms)
# >> I, [2018-07-03T18:10:08.949298 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (5.73ms)
# >> I, [2018-07-03T18:10:08.965712 #69202]  INFO -- : Rendered Fanta::ChatMessageSerializer with ActiveModelSerializers::Adapter::Attributes (0.86ms)
# >> I, [2018-07-03T18:10:08.987156 #69202]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with ActiveModelSerializers::Adapter::Attributes (13.85ms)
# >> I, [2018-07-03T18:10:08.996364 #69202]  INFO -- : Rendered Fanta::ChatMessageSerializer with ActiveModelSerializers::Adapter::Attributes (2.85ms)
# >> I, [2018-07-03T18:10:09.003706 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.41ms)
# >> I, [2018-07-03T18:10:09.020151 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (5.88ms)
# >> I, [2018-07-03T18:10:09.033073 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (5.51ms)
# >> I, [2018-07-03T18:10:09.046624 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (5.65ms)
# >> I, [2018-07-03T18:10:09.063887 #69202]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with ActiveModelSerializers::Adapter::Attributes (13.45ms)
# >> I, [2018-07-03T18:10:09.078695 #69202]  INFO -- : Rendered Fanta::ChatMessageSerializer with ActiveModelSerializers::Adapter::Attributes (3.85ms)
# >> I, [2018-07-03T18:10:09.089012 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (6.4ms)
# >> I, [2018-07-03T18:10:09.119139 #69202]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with ActiveModelSerializers::Adapter::Attributes (14.07ms)
# >> I, [2018-07-03T18:10:09.126934 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (2.82ms)
# >> ["/Users/ikeda/src/shogi_web/app/models/fanta/user.rb:298", :matching_start, ["野良2号"]]
# >> 3
# >> I, [2018-07-03T18:10:09.144395 #69202]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (2.27ms)
# >> I, [2018-07-03T18:10:09.148238 #69202]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.89ms)
# >> I, [2018-07-03T18:10:09.159675 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (7.28ms)
# >> I, [2018-07-03T18:10:09.168160 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (5.83ms)
# >> I, [2018-07-03T18:10:09.175046 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.11ms)
# >> I, [2018-07-03T18:10:09.181913 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.24ms)
# >> I, [2018-07-03T18:10:09.221620 #69202]  INFO -- : Rendered Fanta::ChatMessageSerializer with ActiveModelSerializers::Adapter::Attributes (1.03ms)
# >> I, [2018-07-03T18:10:09.229206 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.08ms)
# >> I, [2018-07-03T18:10:09.244738 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (6.85ms)
# >> I, [2018-07-03T18:10:09.258162 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (6.3ms)
# >> I, [2018-07-03T18:10:09.271791 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (6.69ms)
# >> I, [2018-07-03T18:10:09.289266 #69202]  INFO -- : Rendered Fanta::ChatMessageSerializer with ActiveModelSerializers::Adapter::Attributes (1.1ms)
# >> I, [2018-07-03T18:10:09.309303 #69202]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with ActiveModelSerializers::Adapter::Attributes (14.14ms)
# >> I, [2018-07-03T18:10:09.318433 #69202]  INFO -- : Rendered Fanta::ChatMessageSerializer with ActiveModelSerializers::Adapter::Attributes (2.82ms)
# >> I, [2018-07-03T18:10:09.326751 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (5.18ms)
# >> I, [2018-07-03T18:10:09.356195 #69202]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with ActiveModelSerializers::Adapter::Attributes (14.11ms)
# >> I, [2018-07-03T18:10:09.364990 #69202]  INFO -- : Rendered Fanta::ChatMessageSerializer with ActiveModelSerializers::Adapter::Attributes (2.83ms)
# >> I, [2018-07-03T18:10:09.372905 #69202]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.82ms)
# >> I, [2018-07-03T18:10:09.402349 #69202]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with ActiveModelSerializers::Adapter::Attributes (13.94ms)
# >> |---------------------+-------------------------------------------------------------------------------|
# >> |                  id | 67                                                                            |
# >> |    black_preset_key | 平手                                                                          |
# >> |    white_preset_key | 平手                                                                          |
# >> |        lifetime_key | lifetime_m5                                                                   |
# >> |         platoon_key | platoon_p2vs2                                                                 |
# >> |           full_sfen | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 |
# >> |        clock_counts | {:black=>[], :white=>[]}                                                      |
# >> |     countdown_flags | {:black=>false, :white=>false}                                                |
# >> |            turn_max | 0                                                                             |
# >> |   battle_request_at |                                                                               |
# >> |     auto_matched_at | 2018-07-03 18:10:09 +0900                                                     |
# >> |            begin_at |                                                                               |
# >> |              end_at |                                                                               |
# >> |     last_action_key |                                                                               |
# >> |    win_location_key |                                                                               |
# >> | current_users_count | 0                                                                             |
# >> |   watch_ships_count | 0                                                                             |
# >> |          created_at | 2018-07-03 18:10:09 +0900                                                     |
# >> |          updated_at | 2018-07-03 18:10:09 +0900                                                     |
# >> |---------------------+-------------------------------------------------------------------------------|
# >> |-----+-----------+---------+------------+--------------+----------+---------------------------+---------------------------+------------+---------------------------+---------------------------|
# >> | id  | battle_id | user_id | preset_key | location_key | position | standby_at                | fighting_at               | time_up_at | created_at                | updated_at                |
# >> |-----+-----------+---------+------------+--------------+----------+---------------------------+---------------------------+------------+---------------------------+---------------------------|
# >> | 243 |        67 |      48 | 平手       | black        |        0 | 2018-07-03 18:10:09 +0900 | 2018-07-03 18:10:09 +0900 |            | 2018-07-03 18:10:09 +0900 | 2018-07-03 18:10:09 +0900 |
# >> | 244 |        67 |      47 | 平手       | white        |        1 |                           |                           |            | 2018-07-03 18:10:09 +0900 | 2018-07-03 18:10:09 +0900 |
# >> | 245 |        67 |      48 | 平手       | black        |        2 | 2018-07-03 18:10:09 +0900 | 2018-07-03 18:10:09 +0900 |            | 2018-07-03 18:10:09 +0900 | 2018-07-03 18:10:09 +0900 |
# >> | 246 |        67 |      48 | 平手       | white        |        3 | 2018-07-03 18:10:09 +0900 | 2018-07-03 18:10:09 +0900 |            | 2018-07-03 18:10:09 +0900 | 2018-07-03 18:10:09 +0900 |
# >> |-----+-----------+---------+------------+--------------+----------+---------------------------+---------------------------+------------+---------------------------+---------------------------|
# >> |----+----------------------------------+---------+---------------------------+---------------------------+-------------+---------------+------------+--------------+---------------+-----------------+-----------------+------------------+----------+---------------------------+---------------------------|
# >> | id | key                              | name    | online_at                 | fighting_at               | matching_at | cpu_brain_key | user_agent | lifetime_key | platoon_key   | self_preset_key | oppo_preset_key | robot_accept_key | race_key | created_at                | updated_at                |
# >> |----+----------------------------------+---------+---------------------------+---------------------------+-------------+---------------+------------+--------------+---------------+-----------------+-----------------+------------------+----------+---------------------------+---------------------------|
# >> | 46 | 604b7b6c22126ec8d7f4b5b4b5efb686 | 野良1号 | 2018-07-03 18:10:08 +0900 |                           |             |               |            | lifetime_m5  | platoon_p2vs2 | 平手            | 平手            | accept           | human    | 2018-07-03 18:10:08 +0900 | 2018-07-03 18:10:08 +0900 |
# >> | 47 | 34915fa8ef22db0311754f7814378120 | 野良2号 | 2018-07-03 18:10:08 +0900 |                           |             |               |            | lifetime_m5  | platoon_p2vs2 | 平手            | 平手            | accept           | human    | 2018-07-03 18:10:08 +0900 | 2018-07-03 18:10:09 +0900 |
# >> | 48 | 9d30d384165e4c8654a452205f00b795 | CPU1号  | 2018-07-03 18:10:08 +0900 | 2018-07-03 18:10:09 +0900 |             |               |            | lifetime_m5  | platoon_p1vs1 | 平手            | 平手            | accept           | robot    | 2018-07-03 18:10:08 +0900 | 2018-07-03 18:10:09 +0900 |
# >> |----+----------------------------------+---------+---------------------------+---------------------------+-------------+---------------+------------+--------------+---------------+-----------------+-----------------+------------------+----------+---------------------------+---------------------------|
