#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

module Fanta
  User.destroy_all
  Battle.destroy_all

  user1 = User.create!(race_key: :human, self_preset_key: "平手", oppo_preset_key: "飛車落ち")
  user2 = User.create!(race_key: :robot)
  battle = user1.matching_start

  tp battle
  tp battle.memberships
end
# >> I, [2018-07-03T18:03:32.679246 #68851]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (1810.36ms)
# >> I, [2018-07-03T18:03:32.721034 #68851]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.69ms)
# >> I, [2018-07-03T18:03:32.754914 #68851]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (1.98ms)
# >> I, [2018-07-03T18:03:32.770132 #68851]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.83ms)
# >> I, [2018-07-03T18:03:32.784986 #68851]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (5.0ms)
# >> I, [2018-07-03T18:03:32.792453 #68851]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (2.99ms)
# >> I, [2018-07-03T18:03:32.823050 #68851]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (2.32ms)
# >> I, [2018-07-03T18:03:32.826540 #68851]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.86ms)
# >> I, [2018-07-03T18:03:32.835173 #68851]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.59ms)
# >> I, [2018-07-03T18:03:32.842176 #68851]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.48ms)
# >> I, [2018-07-03T18:03:32.872485 #68851]  INFO -- : Rendered Fanta::ChatMessageSerializer with ActiveModelSerializers::Adapter::Attributes (2.03ms)
# >> I, [2018-07-03T18:03:32.882160 #68851]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.11ms)
# >> I, [2018-07-03T18:03:32.903727 #68851]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (7.51ms)
# >> I, [2018-07-03T18:03:32.917284 #68851]  INFO -- : Rendered Fanta::ChatMessageSerializer with ActiveModelSerializers::Adapter::Attributes (1.51ms)
# >> I, [2018-07-03T18:03:32.944639 #68851]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with ActiveModelSerializers::Adapter::Attributes (10.68ms)
# >> |---------------------+-----------------------------------------------------------------------------|
# >> |                  id | 57                                                                          |
# >> |    black_preset_key | 平手                                                                        |
# >> |    white_preset_key | 飛車落ち                                                                    |
# >> |        lifetime_key | lifetime_m5                                                                 |
# >> |         platoon_key | platoon_p1vs1                                                               |
# >> |           full_sfen | position sfen lnsgkgsnl/7b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 |
# >> |        clock_counts | {:black=>[], :white=>[]}                                                    |
# >> |     countdown_flags | {:black=>false, :white=>false}                                              |
# >> |            turn_max | 0                                                                           |
# >> |   battle_request_at |                                                                             |
# >> |     auto_matched_at | 2018-07-03 18:03:32 +0900                                                   |
# >> |            begin_at |                                                                             |
# >> |              end_at |                                                                             |
# >> |     last_action_key |                                                                             |
# >> |    win_location_key |                                                                             |
# >> | current_users_count | 0                                                                           |
# >> |   watch_ships_count | 0                                                                           |
# >> |          created_at | 2018-07-03 18:03:32 +0900                                                   |
# >> |          updated_at | 2018-07-03 18:03:32 +0900                                                   |
# >> |---------------------+-----------------------------------------------------------------------------|
# >> |-----+-----------+---------+------------+--------------+----------+---------------------------+---------------------------+------------+---------------------------+---------------------------|
# >> | id  | battle_id | user_id | preset_key | location_key | position | standby_at                | fighting_at               | time_up_at | created_at                | updated_at                |
# >> |-----+-----------+---------+------------+--------------+----------+---------------------------+---------------------------+------------+---------------------------+---------------------------|
# >> | 213 |        57 |      31 | 平手       | black        |        0 |                           |                           |            | 2018-07-03 18:03:32 +0900 | 2018-07-03 18:03:32 +0900 |
# >> | 214 |        57 |      32 | 平手       | white        |        1 | 2018-07-03 18:03:32 +0900 | 2018-07-03 18:03:32 +0900 |            | 2018-07-03 18:03:32 +0900 | 2018-07-03 18:03:32 +0900 |
# >> |-----+-----------+---------+------------+--------------+----------+---------------------------+---------------------------+------------+---------------------------+---------------------------|
