#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

module Fanta
  user1 = User.create!(name: "人間", behavior_key: "ningen")
  user2 = User.create!(name: "CPU", behavior_key: "yowai_cpu")
  battle = user1.battle_with(user2)
  battle.reload
  tp battle.memberships
  tp battle
end
# >> D, [2018-06-28T19:49:08.418978 #36241] DEBUG -- : No serializer found for resource: #<Fanta::User id: 365, name: "野良1号", current_battle_id: 242, online_at: "2018-06-28 10:29:28", fighting_at: "2018-06-28 10:29:29", matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-28 10:09:16", updated_at: "2018-06-28 10:29:29">
# >> I, [2018-06-28T19:49:08.420763 #36241]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (1.67ms)
# >> D, [2018-06-28T19:49:08.431318 #36241] DEBUG -- : No serializer found for resource: #<Fanta::User id: 365, name: "野良1号", current_battle_id: 242, online_at: "2018-06-28 10:29:28", fighting_at: "2018-06-28 10:29:29", matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-28 10:09:16", updated_at: "2018-06-28 10:29:29">
# >> I, [2018-06-28T19:49:08.433308 #36241]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (1.9ms)
# >> D, [2018-06-28T19:49:08.497425 #36241] DEBUG -- : No serializer found for resource: #<Fanta::User id: 365, name: "野良1号", current_battle_id: 242, online_at: "2018-06-28 10:29:28", fighting_at: "2018-06-28 10:29:29", matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-28 10:09:16", updated_at: "2018-06-28 10:29:29">
# >> I, [2018-06-28T19:49:08.499585 #36241]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (1.99ms)
# >> D, [2018-06-28T19:49:08.507973 #36241] DEBUG -- : No serializer found for resource: #<Fanta::User id: 365, name: "野良1号", current_battle_id: 242, online_at: "2018-06-28 10:29:28", fighting_at: "2018-06-28 10:29:29", matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-28 10:09:16", updated_at: "2018-06-28 10:29:29">
# >> I, [2018-06-28T19:49:08.510042 #36241]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (2.0ms)
# >> D, [2018-06-28T19:49:08.594140 #36241] DEBUG -- : No serializer found for resource: #<Fanta::User id: 365, name: "野良1号", current_battle_id: 242, online_at: "2018-06-28 10:29:28", fighting_at: "2018-06-28 10:29:29", matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-28 10:09:16", updated_at: "2018-06-28 10:29:29">
# >> I, [2018-06-28T19:49:08.596897 #36241]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (2.67ms)
# >> D, [2018-06-28T19:49:08.611324 #36241] DEBUG -- : No serializer found for resource: #<Fanta::User id: 365, name: "野良1号", current_battle_id: 242, online_at: "2018-06-28 10:29:28", fighting_at: "2018-06-28 10:29:29", matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-28 10:09:16", updated_at: "2018-06-28 10:29:29">
# >> I, [2018-06-28T19:49:08.613961 #36241]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (2.57ms)
# >> D, [2018-06-28T19:49:08.637143 #36241] DEBUG -- : No serializer found for resource: #<Fanta::User id: 365, name: "野良1号", current_battle_id: 242, online_at: "2018-06-28 10:29:28", fighting_at: "2018-06-28 10:29:29", matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-28 10:09:16", updated_at: "2018-06-28 10:29:29">
# >> I, [2018-06-28T19:49:08.639454 #36241]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (2.23ms)
# >> I, [2018-06-28T19:49:10.794302 #36241]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with ActiveModelSerializers::Adapter::Attributes (2089.74ms)
# >> ["/Users/ikeda/src/shogi_web/app/models/fanta/battle.rb:179", :saisyonisasu, "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1", 0]
# >> ["/Users/ikeda/src/shogi_web/app/models/fanta/battle.rb:265", :sasimasu, <▲７八銀(79)>]
# >> ["/Users/ikeda/src/shogi_web/app/models/fanta/battle.rb:187", :saisyonisasu, "position startpos moves 7i7h"]
# >> |-----+-----------+---------+------------+--------------+----------+---------------------------+---------------------------+--------------------+---------------------------+---------------------------|
# >> | id  | battle_id | user_id | preset_key | location_key | position | standby_at                | fighting_at               | time_up_trigger_at | created_at                | updated_at                |
# >> |-----+-----------+---------+------------+--------------+----------+---------------------------+---------------------------+--------------------+---------------------------+---------------------------|
# >> | 539 |       245 |     377 | 平手       | black        |        0 | 2018-06-28 19:49:08 +0900 | 2018-06-28 19:49:08 +0900 |                    | 2018-06-28 19:49:08 +0900 | 2018-06-28 19:49:08 +0900 |
# >> | 540 |       245 |     376 | 平手       | white        |        1 |                           |                           |                    | 2018-06-28 19:49:08 +0900 | 2018-06-28 19:49:08 +0900 |
# >> |-----+-----------+---------+------------+--------------+----------+---------------------------+---------------------------+--------------------+---------------------------+---------------------------|
# >> |---------------------+--------------------------------|
# >> |                  id | 245                            |
# >> |    black_preset_key | 平手                           |
# >> |    white_preset_key | 平手                           |
# >> |        lifetime_key | lifetime_m5                    |
# >> |         platoon_key | platoon_p1vs1                  |
# >> |           full_sfen | position startpos moves 7i7h   |
# >> |        clock_counts | {:black=>[1], :white=>[]}      |
# >> | countdown_mode_hash | {:black=>false, :white=>false} |
# >> |            turn_max | 1                              |
# >> |   battle_request_at | 2018-06-28 19:49:08 +0900      |
# >> |     auto_matched_at |                                |
# >> |            begin_at |                                |
# >> |              end_at |                                |
# >> |     last_action_key |                                |
# >> |    win_location_key |                                |
# >> | current_users_count | 1                              |
# >> |   watch_ships_count | 0                              |
# >> |          created_at | 2018-06-28 19:49:08 +0900      |
# >> |          updated_at | 2018-06-28 19:49:11 +0900      |
# >> |---------------------+--------------------------------|
