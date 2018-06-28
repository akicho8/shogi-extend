#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

module Fanta
  User.destroy_all
  Battle.destroy_all

  30.times do
    alice = User.create!
    bob = User.create!
    [alice, bob].each do |user|
      user.matching_start
    end
  end
end
# ~> /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activemodel-5.2.0/lib/active_model/attribute_methods.rb:430:in `method_missing': undefined local variable or method `data' for #<Battle:0x00007ff95465a180> (NameError)
# ~>    from /Users/ikeda/src/shogi_web/app/models/fanta/battle.rb:232:in `oute_houti_check'
# ~>    from /Users/ikeda/src/shogi_web/app/models/fanta/battle.rb:180:in `block in saisyonisasu'
# ~>    from /Users/ikeda/src/shogi_web/app/models/fanta/battle.rb:177:in `catch'
# ~>    from /Users/ikeda/src/shogi_web/app/models/fanta/battle.rb:177:in `saisyonisasu'
# ~>    from /Users/ikeda/src/shogi_web/app/models/fanta/user.rb:242:in `battle_setup'
# ~>    from /Users/ikeda/src/shogi_web/app/models/fanta/user.rb:194:in `matching_start'
# ~>    from -:8:in `block (2 levels) in <main>'
# ~>    from -:7:in `each'
# ~>    from -:7:in `block in <main>'
# ~>    from -:4:in `times'
# ~>    from -:4:in `<main>'
# >> D, [2018-06-28T18:34:50.069640 #32753] DEBUG -- : No serializer found for resource: #<User id: 1, name: "野良1号", current_battle_id: 55, online_at: "2018-06-28 09:33:10", fighting_at: "2018-06-28 09:33:10", matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p2vs2", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-28 05:57:30", updated_at: "2018-06-28 09:33:10">
# >> I, [2018-06-28T18:34:50.070327 #32753]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with User::ActiveRecord_Relation (0.58ms)
# >> D, [2018-06-28T18:34:50.078912 #32753] DEBUG -- : No serializer found for resource: #<User id: 1, name: "野良1号", current_battle_id: 55, online_at: "2018-06-28 09:33:10", fighting_at: "2018-06-28 09:33:10", matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p2vs2", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-28 05:57:30", updated_at: "2018-06-28 09:33:10">
# >> I, [2018-06-28T18:34:50.079575 #32753]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with User::ActiveRecord_Relation (0.61ms)
# >> D, [2018-06-28T18:34:50.085991 #32753] DEBUG -- : No serializer found for resource: #<User id: 1, name: "野良1号", current_battle_id: 55, online_at: "2018-06-28 09:33:10", fighting_at: "2018-06-28 09:33:10", matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p2vs2", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-28 05:57:30", updated_at: "2018-06-28 09:33:10">
# >> I, [2018-06-28T18:34:50.086716 #32753]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with User::ActiveRecord_Relation (0.66ms)
# >> D, [2018-06-28T18:34:50.101997 #32753] DEBUG -- : No serializer found for resource: #<User id: 1, name: "野良1号", current_battle_id: 55, online_at: "2018-06-28 09:33:10", fighting_at: "2018-06-28 09:33:10", matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p2vs2", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-28 05:57:30", updated_at: "2018-06-28 09:33:10">
# >> I, [2018-06-28T18:34:50.103016 #32753]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with User::ActiveRecord_Relation (0.94ms)
# >> D, [2018-06-28T18:34:50.164556 #32753] DEBUG -- : No serializer found for resource: #<User id: 1, name: "野良1号", current_battle_id: 55, online_at: "2018-06-28 09:33:10", fighting_at: "2018-06-28 09:33:10", matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p2vs2", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-28 05:57:30", updated_at: "2018-06-28 09:33:10">
# >> I, [2018-06-28T18:34:50.165277 #32753]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with User::ActiveRecord_Relation (0.66ms)
# >> D, [2018-06-28T18:34:50.172025 #32753] DEBUG -- : No serializer found for resource: #<User id: 1, name: "野良1号", current_battle_id: 55, online_at: "2018-06-28 09:33:10", fighting_at: "2018-06-28 09:33:10", matching_at: nil, lifetime_key: "lifetime_m5", platoon_key: "platoon_p2vs2", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", behavior_key: nil, created_at: "2018-06-28 05:57:30", updated_at: "2018-06-28 09:33:10">
# >> I, [2018-06-28T18:34:50.172703 #32753]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with User::ActiveRecord_Relation (0.59ms)
# >> ["/Users/ikeda/src/shogi_web/app/models/fanta/battle.rb:178", :saisyonisasu, "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"]
