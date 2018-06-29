#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

module Fanta
  User.destroy_all
  Battle.destroy_all

  alice = User.create!
  bob = User.create!(behavior_key: :yowai_cpu)
  alice.battle_with(bob)
end
# >> D, [2018-06-29T13:42:34.244569 #75278] DEBUG -- : No serializer found for resource: #<Fanta::User id: 26, name: "野良2号", current_battle_id: 61, online_at: "2018-06-29 04:42:16", fighting_at: "2018-06-29 04:42:16", matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: "yowai_cpu", created_at: "2018-06-29 04:42:16", updated_at: "2018-06-29 04:42:16">
# >> I, [2018-06-29T13:42:34.244906 #75278]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (0.2ms)
# >> I, [2018-06-29T13:42:34.302799 #75278]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with ActiveModelSerializers::Adapter::Attributes (0.11ms)
# >> D, [2018-06-29T13:42:34.324101 #75278] DEBUG -- : No serializer found for resource: #<Fanta::User id: 27, name: "野良1号", current_battle_id: nil, online_at: "2018-06-29 04:42:34", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-29 04:42:34", updated_at: "2018-06-29 04:42:34">
# >> I, [2018-06-29T13:42:34.324283 #75278]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (0.12ms)
# >> D, [2018-06-29T13:42:34.331790 #75278] DEBUG -- : No serializer found for resource: #<Fanta::User id: 27, name: "野良1号", current_battle_id: nil, online_at: "2018-06-29 04:42:34", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-29 04:42:34", updated_at: "2018-06-29 04:42:34">
# >> I, [2018-06-29T13:42:34.332139 #75278]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (0.28ms)
# >> D, [2018-06-29T13:42:34.361249 #75278] DEBUG -- : No serializer found for resource: #<Fanta::User id: 27, name: "野良1号", current_battle_id: nil, online_at: "2018-06-29 04:42:34", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-29 04:42:34", updated_at: "2018-06-29 04:42:34">
# >> I, [2018-06-29T13:42:34.361900 #75278]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (0.59ms)
# >> D, [2018-06-29T13:42:34.367226 #75278] DEBUG -- : No serializer found for resource: #<Fanta::User id: 27, name: "野良1号", current_battle_id: nil, online_at: "2018-06-29 04:42:34", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-29 04:42:34", updated_at: "2018-06-29 04:42:34">
# >> I, [2018-06-29T13:42:34.367551 #75278]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (0.26ms)
# >> D, [2018-06-29T13:42:34.413788 #75278] DEBUG -- : No serializer found for resource: #<Fanta::User id: 27, name: "野良1号", current_battle_id: nil, online_at: "2018-06-29 04:42:34", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-29 04:42:34", updated_at: "2018-06-29 04:42:34">
# >> I, [2018-06-29T13:42:34.414095 #75278]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (0.25ms)
# >> D, [2018-06-29T13:42:34.423079 #75278] DEBUG -- : No serializer found for resource: #<Fanta::User id: 27, name: "野良1号", current_battle_id: nil, online_at: "2018-06-29 04:42:34", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-29 04:42:34", updated_at: "2018-06-29 04:42:34">
# >> I, [2018-06-29T13:42:34.423402 #75278]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (0.26ms)
# >> D, [2018-06-29T13:42:34.437449 #75278] DEBUG -- : No serializer found for resource: #<Fanta::User id: 27, name: "野良1号", current_battle_id: nil, online_at: "2018-06-29 04:42:34", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-29 04:42:34", updated_at: "2018-06-29 04:42:34">
# >> I, [2018-06-29T13:42:34.437754 #75278]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (0.24ms)
# >> I, [2018-06-29T13:42:36.434777 #75278]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with ActiveModelSerializers::Adapter::Attributes (1962.21ms)
