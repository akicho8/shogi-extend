#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

module Fanta
  User.destroy_all
  Battle.destroy_all

  alice = User.create!
  bob = User.create!(race_key: :robot)
  alice.battle_with(bob)
end
# >> D, [2018-06-29T19:47:42.027962 #93950] DEBUG -- : No serializer found for resource: #<Fanta::User id: 50, key: "e7d2eb1256682e4cf7af253a5c3d24ad", name: "野良2号", current_battle_id: nil, online_at: "2018-06-29 10:44:42", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", race_key: "robot", cpu_brain_key: nil, created_at: "2018-06-29 10:44:42", updated_at: "2018-06-29 10:44:42">
# >> I, [2018-06-29T19:47:42.028346 #93950]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (0.24ms)
# >> I, [2018-06-29T19:47:42.065101 #93950]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with ActiveModelSerializers::Adapter::Attributes (0.1ms)
# >> D, [2018-06-29T19:47:42.079150 #93950] DEBUG -- : No serializer found for resource: #<Fanta::User id: 51, key: "33e8a4c5f9a7e2d16bafc3921cf28fcd", name: "野良1号", current_battle_id: nil, online_at: "2018-06-29 10:47:42", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", race_key: "human", cpu_brain_key: nil, created_at: "2018-06-29 10:47:42", updated_at: "2018-06-29 10:47:42">
# >> I, [2018-06-29T19:47:42.079440 #93950]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (0.14ms)
# >> D, [2018-06-29T19:47:42.087937 #93950] DEBUG -- : No serializer found for resource: #<Fanta::User id: 51, key: "33e8a4c5f9a7e2d16bafc3921cf28fcd", name: "野良1号", current_battle_id: nil, online_at: "2018-06-29 10:47:42", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", race_key: "human", cpu_brain_key: nil, created_at: "2018-06-29 10:47:42", updated_at: "2018-06-29 10:47:42">
# >> I, [2018-06-29T19:47:42.088352 #93950]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (0.3ms)
# >> D, [2018-06-29T19:47:42.137969 #93950] DEBUG -- : No serializer found for resource: #<Fanta::User id: 51, key: "33e8a4c5f9a7e2d16bafc3921cf28fcd", name: "野良1号", current_battle_id: nil, online_at: "2018-06-29 10:47:42", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", race_key: "human", cpu_brain_key: nil, created_at: "2018-06-29 10:47:42", updated_at: "2018-06-29 10:47:42">
# >> I, [2018-06-29T19:47:42.138322 #93950]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (0.28ms)
# >> D, [2018-06-29T19:47:42.142662 #93950] DEBUG -- : No serializer found for resource: #<Fanta::User id: 51, key: "33e8a4c5f9a7e2d16bafc3921cf28fcd", name: "野良1号", current_battle_id: nil, online_at: "2018-06-29 10:47:42", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", race_key: "human", cpu_brain_key: nil, created_at: "2018-06-29 10:47:42", updated_at: "2018-06-29 10:47:42">
# >> I, [2018-06-29T19:47:42.142971 #93950]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (0.25ms)
# >> I, [2018-06-29T19:47:44.701525 #93950]  INFO -- : Rendered Fanta::ChatMessageSerializer with ActiveModelSerializers::Adapter::Attributes (2455.03ms)
# >> D, [2018-06-29T19:47:44.706565 #93950] DEBUG -- : No serializer found for resource: #<Fanta::User id: 51, key: "33e8a4c5f9a7e2d16bafc3921cf28fcd", name: "野良1号", current_battle_id: nil, online_at: "2018-06-29 10:47:42", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", race_key: "human", cpu_brain_key: nil, created_at: "2018-06-29 10:47:42", updated_at: "2018-06-29 10:47:42">
# >> I, [2018-06-29T19:47:44.706888 #93950]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (0.24ms)
# >> D, [2018-06-29T19:47:44.714196 #93950] DEBUG -- : No serializer found for resource: #<Fanta::User id: 51, key: "33e8a4c5f9a7e2d16bafc3921cf28fcd", name: "野良1号", current_battle_id: nil, online_at: "2018-06-29 10:47:42", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", race_key: "human", cpu_brain_key: nil, created_at: "2018-06-29 10:47:42", updated_at: "2018-06-29 10:47:42">
# >> I, [2018-06-29T19:47:44.714518 #93950]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (0.26ms)
# >> D, [2018-06-29T19:47:44.727029 #93950] DEBUG -- : No serializer found for resource: #<Fanta::User id: 51, key: "33e8a4c5f9a7e2d16bafc3921cf28fcd", name: "野良1号", current_battle_id: nil, online_at: "2018-06-29 10:47:42", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", race_key: "human", cpu_brain_key: nil, created_at: "2018-06-29 10:47:42", updated_at: "2018-06-29 10:47:42">
# >> I, [2018-06-29T19:47:44.727425 #93950]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (0.34ms)
# >> I, [2018-06-29T19:47:44.751435 #93950]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with ActiveModelSerializers::Adapter::Attributes (12.13ms)
