#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

general_battle = GeneralBattle.create!
tp general_battle
tp general_battle.meta_info[:header]

general_battle = GeneralBattle.create!(kifu_body: "６八銀")
tp general_battle
tp general_battle.meta_info[:header]
tp general_battle.general_memberships # => #<ActiveRecord::Associations::CollectionProxy [#<GeneralMembership id: 21, general_battle_id: 11, judge_key: "win", location_key: "black", position: 0, created_at: "2018-03-11 03:18:20", updated_at: "2018-03-11 03:18:20">, #<GeneralMembership id: 22, general_battle_id: 11, judge_key: "lose", location_key: "white", position: 1, created_at: "2018-03-11 03:18:20", updated_at: "2018-03-11 03:18:20">]>
tp general_battle.convert_infos.count  # => 


# ~> /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activemodel-5.1.5/lib/active_model/attribute_methods.rb:432:in `method_missing': undefined method `convert_infos' for #<GeneralBattle:0x00007fd8ec1d9ff8> (NoMethodError)
# ~> Did you mean?  converted_infos
# ~>                converted_infos=
# ~> 	from -:12:in `<main>'
# >> |--------------------------+------------------------------------------------------------------------------------------------------|
# >> |                       id | 10                                                                                                   |
# >> |               battle_key | 0c21b5d07d232353d1dba8b4d6f09639                                                                     |
# >> |               battled_at | 0001-01-01 00:00:00 +0900                                                                            |
# >> |                kifu_body |                                                                                                      |
# >> | general_battle_state_key | TORYO                                                                                                |
# >> |                 turn_max | 0                                                                                                    |
# >> |                meta_info | {:header=>{"手合割"=>"平手"}, :detail_names=>[[], []], :simple_names=>[[], []], :skill_set_hash=>{}} |
# >> |             mountain_url |                                                                                                      |
# >> |          last_accessd_at | 2018-03-11 12:18:19 +0900                                                                            |
# >> |               created_at | 2018-03-11 12:18:19 +0900                                                                            |
# >> |               updated_at | 2018-03-11 12:18:19 +0900                                                                            |
# >> |--------------------------+------------------------------------------------------------------------------------------------------|
# >> |--------+------|
# >> | 手合割 | 平手 |
# >> |--------+------|
# >> |--------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                       id | 11                                                                                                                                                   |
# >> |               battle_key | 1e3e8964bfa59d9dc60048b1a7477da4                                                                                                                     |
# >> |               battled_at | 0001-01-01 00:00:00 +0900                                                                                                                            |
# >> |                kifu_body | ６八銀                                                                                                                                               |
# >> | general_battle_state_key | TORYO                                                                                                                                                |
# >> |                 turn_max | 1                                                                                                                                                    |
# >> |                meta_info | {:header=>{"先手の戦型"=>"嬉野流", "手合割"=>"平手"}, :detail_names=>[[], []], :simple_names=>[[], []], :skill_set_hash=>{"先手の戦型"=>["嬉野流"]}} |
# >> |             mountain_url |                                                                                                                                                      |
# >> |          last_accessd_at | 2018-03-11 12:18:20 +0900                                                                                                                            |
# >> |               created_at | 2018-03-11 12:18:20 +0900                                                                                                                            |
# >> |               updated_at | 2018-03-11 12:18:20 +0900                                                                                                                            |
# >> |--------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |------------+--------|
# >> | 先手の戦型 | 嬉野流 |
# >> |     手合割 | 平手   |
# >> |------------+--------|
# >> |----+--------------------------+-----------+--------------+----------+---------------------------+---------------------------|
# >> | id | general_battle_id | judge_key | location_key | position | created_at                | updated_at                |
# >> |----+--------------------------+-----------+--------------+----------+---------------------------+---------------------------|
# >> | 21 |                       11 | win       | black        |        0 | 2018-03-11 12:18:20 +0900 | 2018-03-11 12:18:20 +0900 |
# >> | 22 |                       11 | lose      | white        |        1 | 2018-03-11 12:18:20 +0900 | 2018-03-11 12:18:20 +0900 |
# >> |----+--------------------------+-----------+--------------+----------+---------------------------+---------------------------|
