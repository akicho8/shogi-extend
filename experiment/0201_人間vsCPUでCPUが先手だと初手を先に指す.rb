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
# >> D, [2018-06-29T14:23:53.538910 #76880] DEBUG -- : No serializer found for resource: #<Fanta::User id: 1, name: "野良1号", current_battle_id: nil, online_at: "2018-06-29 05:18:23", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p2vs2", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-29 05:18:23", updated_at: "2018-06-29 05:18:23">
# >> I, [2018-06-29T14:23:53.539826 #76880]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (0.8ms)
# >> D, [2018-06-29T14:23:53.548543 #76880] DEBUG -- : No serializer found for resource: #<Fanta::User id: 1, name: "野良1号", current_battle_id: nil, online_at: "2018-06-29 05:18:23", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p2vs2", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-29 05:18:23", updated_at: "2018-06-29 05:18:23">
# >> I, [2018-06-29T14:23:53.549514 #76880]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (0.92ms)
# >> D, [2018-06-29T14:23:53.604939 #76880] DEBUG -- : No serializer found for resource: #<Fanta::User id: 1, name: "野良1号", current_battle_id: nil, online_at: "2018-06-29 05:18:23", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p2vs2", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-29 05:18:23", updated_at: "2018-06-29 05:18:23">
# >> I, [2018-06-29T14:23:53.606018 #76880]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (1.02ms)
# >> D, [2018-06-29T14:23:53.611638 #76880] DEBUG -- : No serializer found for resource: #<Fanta::User id: 1, name: "野良1号", current_battle_id: nil, online_at: "2018-06-29 05:18:23", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p2vs2", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-29 05:18:23", updated_at: "2018-06-29 05:18:23">
# >> I, [2018-06-29T14:23:53.612579 #76880]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (0.88ms)
# >> D, [2018-06-29T14:23:53.677201 #76880] DEBUG -- : No serializer found for resource: #<Fanta::User id: 1, name: "野良1号", current_battle_id: nil, online_at: "2018-06-29 05:18:23", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p2vs2", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-29 05:18:23", updated_at: "2018-06-29 05:18:23">
# >> I, [2018-06-29T14:23:53.678273 #76880]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (1.01ms)
# >> D, [2018-06-29T14:23:53.689548 #76880] DEBUG -- : No serializer found for resource: #<Fanta::User id: 1, name: "野良1号", current_battle_id: nil, online_at: "2018-06-29 05:18:23", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p2vs2", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-29 05:18:23", updated_at: "2018-06-29 05:18:23">
# >> I, [2018-06-29T14:23:53.690807 #76880]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (1.2ms)
# >> D, [2018-06-29T14:23:53.707851 #76880] DEBUG -- : No serializer found for resource: #<Fanta::User id: 1, name: "野良1号", current_battle_id: nil, online_at: "2018-06-29 05:18:23", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p2vs2", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-29 05:18:23", updated_at: "2018-06-29 05:18:23">
# >> I, [2018-06-29T14:23:53.709132 #76880]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (1.2ms)
# >> I, [2018-06-29T14:23:55.726884 #76880]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with ActiveModelSerializers::Adapter::Attributes (1970.41ms)
# >> |-----+-----------+---------+------------+--------------+----------+---------------------------+---------------------------+------------+---------------------------+---------------------------|
# >> | id  | battle_id | user_id | preset_key | location_key | position | standby_at                | fighting_at               | time_up_at | created_at                | updated_at                |
# >> |-----+-----------+---------+------------+--------------+----------+---------------------------+---------------------------+------------+---------------------------+---------------------------|
# >> | 153 |        52 |       7 | 平手       | black        |        0 | 2018-06-29 14:23:53 +0900 | 2018-06-29 14:23:53 +0900 |            | 2018-06-29 14:23:53 +0900 | 2018-06-29 14:23:53 +0900 |
# >> | 154 |        52 |       6 | 平手       | white        |        1 |                           |                           |            | 2018-06-29 14:23:53 +0900 | 2018-06-29 14:23:53 +0900 |
# >> |-----+-----------+---------+------------+--------------+----------+---------------------------+---------------------------+------------+---------------------------+---------------------------|
# >> |---------------------+--------------------------------|
# >> |                  id | 52                             |
# >> |    black_preset_key | 平手                           |
# >> |    white_preset_key | 平手                           |
# >> |        lifetime_key | lifetime_m5                    |
# >> |         platoon_key | platoon_p1vs1                  |
# >> |           full_sfen | position startpos moves 9i9h   |
# >> |        clock_counts | {:black=>[1], :white=>[]}      |
# >> | countdown_flags | {:black=>false, :white=>false} |
# >> |            turn_max | 1                              |
# >> |   battle_request_at | 2018-06-29 14:23:53 +0900      |
# >> |     auto_matched_at |                                |
# >> |            begin_at |                                |
# >> |              end_at |                                |
# >> |     last_action_key |                                |
# >> |    win_location_key |                                |
# >> | current_users_count | 1                              |
# >> |   watch_ships_count | 0                              |
# >> |          created_at | 2018-06-29 14:23:53 +0900      |
# >> |          updated_at | 2018-06-29 14:23:55 +0900      |
# >> |---------------------+--------------------------------|
