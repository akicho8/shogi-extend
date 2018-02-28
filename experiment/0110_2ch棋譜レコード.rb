#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

general_battle_record = GeneralBattleRecord.create!
tp general_battle_record
tp general_battle_record.meta_info[:header]

general_battle_record = GeneralBattleRecord.create!(kifu_body: "６八銀")
tp general_battle_record
tp general_battle_record.meta_info[:header]

# >> |--------------------------+------------------------------------------------------------------------------------------------------|
# >> |                       id | 11                                                                                                   |
# >> |               battle_key | 3be29aa66ed436598d65019a8ea3a42d                                                                     |
# >> |               battled_at | 0001-01-01 00:00:00 +0900                                                                            |
# >> |                kifu_body |                                                                                                      |
# >> | general_battle_state_key | TORYO                                                                                                |
# >> |                 turn_max | 0                                                                                                    |
# >> |                meta_info | {:header=>{"手合割"=>"平手"}, :detail_names=>[[], []], :simple_names=>[[], []], :skill_set_hash=>{}} |
# >> |             mountain_url |                                                                                                      |
# >> |               created_at | 2018-02-28 15:50:49 +0900                                                                            |
# >> |               updated_at | 2018-02-28 15:50:49 +0900                                                                            |
# >> |--------------------------+------------------------------------------------------------------------------------------------------|
# >> |--------+------|
# >> | 手合割 | 平手 |
# >> |--------+------|
# >> |--------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                       id | 12                                                                                                                                                   |
# >> |               battle_key | 1a9f87089740f9cdd2dbcd222d763c21                                                                                                                     |
# >> |               battled_at | 0001-01-01 00:00:00 +0900                                                                                                                            |
# >> |                kifu_body | ６八銀                                                                                                                                               |
# >> | general_battle_state_key | TORYO                                                                                                                                                |
# >> |                 turn_max | 1                                                                                                                                                    |
# >> |                meta_info | {:header=>{"先手の戦型"=>"嬉野流", "手合割"=>"平手"}, :detail_names=>[[], []], :simple_names=>[[], []], :skill_set_hash=>{"先手の戦型"=>["嬉野流"]}} |
# >> |             mountain_url |                                                                                                                                                      |
# >> |               created_at | 2018-02-28 15:50:49 +0900                                                                                                                            |
# >> |               updated_at | 2018-02-28 15:50:49 +0900                                                                                                                            |
# >> |--------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |------------+--------|
# >> | 先手の戦型 | 嬉野流 |
# >> |     手合割 | 平手   |
# >> |------------+--------|
