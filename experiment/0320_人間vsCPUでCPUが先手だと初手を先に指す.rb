#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

module Colosseum
  user1 = User.create!(name: "人間")
  user2 = User.create!(name: "CPU", race_key: :robot)
  battle = user1.battle_with(user2)
  battle.reload
  tp battle.memberships
  tp battle
end
# >> D, [2018-06-29T14:47:40.420333 #77908] DEBUG -- : No serializer found for resource: #<Colosseum::User id: 9, name: "名無しの棋士1号", current_battle_id: nil, online_at: "2018-06-29 05:47:26", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", team_key: "team_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", race_key: nil, created_at: "2018-06-29 05:47:26", updated_at: "2018-06-29 05:47:26">
# >> I, [2018-06-29T14:47:40.420912 #77908]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Colosseum::User::ActiveRecord_Relation (0.43ms)
# >> D, [2018-06-29T14:47:40.428003 #77908] DEBUG -- : No serializer found for resource: #<Colosseum::User id: 9, name: "名無しの棋士1号", current_battle_id: nil, online_at: "2018-06-29 05:47:26", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", team_key: "team_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", race_key: nil, created_at: "2018-06-29 05:47:26", updated_at: "2018-06-29 05:47:26">
# >> I, [2018-06-29T14:47:40.428542 #77908]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Colosseum::User::ActiveRecord_Relation (0.49ms)
# >> D, [2018-06-29T14:47:40.485516 #77908] DEBUG -- : No serializer found for resource: #<Colosseum::User id: 9, name: "名無しの棋士1号", current_battle_id: nil, online_at: "2018-06-29 05:47:26", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", team_key: "team_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", race_key: nil, created_at: "2018-06-29 05:47:26", updated_at: "2018-06-29 05:47:26">
# >> I, [2018-06-29T14:47:40.486132 #77908]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Colosseum::User::ActiveRecord_Relation (0.55ms)
# >> D, [2018-06-29T14:47:40.491259 #77908] DEBUG -- : No serializer found for resource: #<Colosseum::User id: 9, name: "名無しの棋士1号", current_battle_id: nil, online_at: "2018-06-29 05:47:26", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", team_key: "team_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", race_key: nil, created_at: "2018-06-29 05:47:26", updated_at: "2018-06-29 05:47:26">
# >> I, [2018-06-29T14:47:40.491870 #77908]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Colosseum::User::ActiveRecord_Relation (0.56ms)
# >> D, [2018-06-29T14:47:40.557637 #77908] DEBUG -- : No serializer found for resource: #<Colosseum::User id: 9, name: "名無しの棋士1号", current_battle_id: nil, online_at: "2018-06-29 05:47:26", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", team_key: "team_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", race_key: nil, created_at: "2018-06-29 05:47:26", updated_at: "2018-06-29 05:47:26">
# >> I, [2018-06-29T14:47:40.558167 #77908]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Colosseum::User::ActiveRecord_Relation (0.47ms)
# >> D, [2018-06-29T14:47:40.567340 #77908] DEBUG -- : No serializer found for resource: #<Colosseum::User id: 9, name: "名無しの棋士1号", current_battle_id: nil, online_at: "2018-06-29 05:47:26", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", team_key: "team_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", race_key: nil, created_at: "2018-06-29 05:47:26", updated_at: "2018-06-29 05:47:26">
# >> I, [2018-06-29T14:47:40.568133 #77908]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Colosseum::User::ActiveRecord_Relation (0.73ms)
# >> D, [2018-06-29T14:47:40.583140 #77908] DEBUG -- : No serializer found for resource: #<Colosseum::User id: 9, name: "名無しの棋士1号", current_battle_id: nil, online_at: "2018-06-29 05:47:26", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", team_key: "team_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", race_key: nil, created_at: "2018-06-29 05:47:26", updated_at: "2018-06-29 05:47:26">
# >> I, [2018-06-29T14:47:40.583720 #77908]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Colosseum::User::ActiveRecord_Relation (0.52ms)
# >> I, [2018-06-29T14:47:42.529184 #77908]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with ActiveModelSerializers::Adapter::Attributes (1898.44ms)
# >> |-----+-----------+---------+------------+--------------+----------+---------------------------+---------------------------+------------+---------------------------+---------------------------|
# >> | id  | battle_id | user_id | preset_key | location_key | position | standby_at                | fighting_at               | time_up_at | created_at                | updated_at                |
# >> |-----+-----------+---------+------------+--------------+----------+---------------------------+---------------------------+------------+---------------------------+---------------------------|
# >> | 159 |        55 |      12 | 平手       | black        |        0 | 2018-06-29 14:47:40 +0900 | 2018-06-29 14:47:40 +0900 |            | 2018-06-29 14:47:40 +0900 | 2018-06-29 14:47:40 +0900 |
# >> | 160 |        55 |      11 | 平手       | white        |        1 |                           |                           |            | 2018-06-29 14:47:40 +0900 | 2018-06-29 14:47:40 +0900 |
# >> |-----+-----------+---------+------------+--------------+----------+---------------------------+---------------------------+------------+---------------------------+---------------------------|
# >> |---------------------+--------------------------------|
# >> |                  id | 55                             |
# >> |    black_preset_key | 平手                           |
# >> |    white_preset_key | 平手                           |
# >> |        lifetime_key | lifetime_m5                    |
# >> |         team_key | team_p1vs1                  |
# >> |           full_sfen | position startpos moves 4i5h   |
# >> |        clock_counts | {:black=>[1], :white=>[]}      |
# >> |     countdown_flags | {:black=>false, :white=>false} |
# >> |            turn_max | 1                              |
# >> |   battle_request_at | 2018-06-29 14:47:40 +0900      |
# >> |     auto_matched_at |                                |
# >> |            begin_at |                                |
# >> |              end_at |                                |
# >> |     last_action_key |                                |
# >> |    win_location_key |                                |
# >> | current_users_count | 1                              |
# >> |   watch_ships_count | 0                              |
# >> |          created_at | 2018-06-29 14:47:40 +0900      |
# >> |          updated_at | 2018-06-29 14:47:42 +0900      |
# >> |---------------------+--------------------------------|
