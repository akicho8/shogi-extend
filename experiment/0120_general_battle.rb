#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

battle = General::Battle.create!
tp battle
tp battle.meta_info[:header]

battle = General::Battle.create!(kifu_body: "６八銀")
tp battle
tp battle.meta_info[:header]
tp battle.memberships # => #<ActiveRecord::Associations::CollectionProxy [#<General::Membership id: 13, battle_id: 7, judge_key: "win", location_key: "black", position: 0, created_at: "2018-06-17 13:54:24", updated_at: "2018-06-17 13:54:24", defense_tag_list: nil, attack_tag_list: nil>, #<General::Membership id: 14, battle_id: 7, judge_key: "lose", location_key: "white", position: 1, created_at: "2018-06-17 13:54:24", updated_at: "2018-06-17 13:54:24", defense_tag_list: nil, attack_tag_list: nil>]>
tp battle.convert_infos.count  # => 


# ~> /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activemodel-5.2.0/lib/active_model/attribute_methods.rb:430:in `method_missing': undefined method `convert_infos' for #<General::Battle:0x00007fc761c10248> (NoMethodError)
# ~> Did you mean?  converted_infos
# ~>                converted_infos=
# ~> 	from -:12:in `<main>'
# >> ["/Users/ikeda/src/shogi_web/config/initializers/0180_active_model_serializers.rb:11", nil, :ams_sr]
# >> |------------------+------------------------------------------------------------------------------------------------------|
# >> |               id | 6                                                                                                    |
# >> |       battle_key | 7b1ecf917e29fee02b11b6a76b194f5e                                                                     |
# >> |       battled_at | 0001-01-01 00:00:00 +0900                                                                            |
# >> |        kifu_body |                                                                                                      |
# >> | battle_state_key | TORYO                                                                                                |
# >> |         turn_max | 0                                                                                                    |
# >> |        meta_info | {:header=>{"手合割"=>"平手"}, :detail_names=>[[], []], :simple_names=>[[], []], :skill_set_hash=>{}} |
# >> |  last_accessd_at | 2018-06-17 22:54:24 +0900                                                                            |
# >> |       created_at | 2018-06-17 22:54:24 +0900                                                                            |
# >> |       updated_at | 2018-06-17 22:54:24 +0900                                                                            |
# >> | defense_tag_list |                                                                                                      |
# >> |  attack_tag_list |                                                                                                      |
# >> |   other_tag_list |                                                                                                      |
# >> |  secret_tag_list |                                                                                                      |
# >> |------------------+------------------------------------------------------------------------------------------------------|
# >> |--------+------|
# >> | 手合割 | 平手 |
# >> |--------+------|
# >> |------------------+------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |               id | 7                                                                                                                                                    |
# >> |       battle_key | b39df6093c7baaad97708a025a1cb5d7                                                                                                                     |
# >> |       battled_at | 0001-01-01 00:00:00 +0900                                                                                                                            |
# >> |        kifu_body | ６八銀                                                                                                                                               |
# >> | battle_state_key | TORYO                                                                                                                                                |
# >> |         turn_max | 1                                                                                                                                                    |
# >> |        meta_info | {:header=>{"先手の戦型"=>"嬉野流", "手合割"=>"平手"}, :detail_names=>[[], []], :simple_names=>[[], []], :skill_set_hash=>{"先手の戦型"=>["嬉野流"]}} |
# >> |  last_accessd_at | 2018-06-17 22:54:24 +0900                                                                                                                            |
# >> |       created_at | 2018-06-17 22:54:24 +0900                                                                                                                            |
# >> |       updated_at | 2018-06-17 22:54:24 +0900                                                                                                                            |
# >> | defense_tag_list |                                                                                                                                                      |
# >> |  attack_tag_list |                                                                                                                                                      |
# >> |   other_tag_list |                                                                                                                                                      |
# >> |  secret_tag_list |                                                                                                                                                      |
# >> |------------------+------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |------------+--------|
# >> | 先手の戦型 | 嬉野流 |
# >> |     手合割 | 平手   |
# >> |------------+--------|
# >> |----+-----------+-----------+--------------+----------+---------------------------+---------------------------+------------------+-----------------|
# >> | id | battle_id | judge_key | location_key | position | created_at                | updated_at                | defense_tag_list | attack_tag_list |
# >> |----+-----------+-----------+--------------+----------+---------------------------+---------------------------+------------------+-----------------|
# >> | 13 |         7 | win       | black        |        0 | 2018-06-17 22:54:24 +0900 | 2018-06-17 22:54:24 +0900 |                  |                 |
# >> | 14 |         7 | lose      | white        |        1 | 2018-06-17 22:54:24 +0900 | 2018-06-17 22:54:24 +0900 |                  |                 |
# >> |----+-----------+-----------+--------------+----------+---------------------------+---------------------------+------------------+-----------------|
