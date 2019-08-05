#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

XyGameRecord.destroy_all
XyGameRecord.create!(rule_key: "xy_rule_1c", name: "(name1)", spent_msec: 59.123)
XyGameRecord.create!(rule_key: "xy_rule_2c", name: "(name2)", spent_msec: 60.123)
# tp XyGameRecord

tp XyGameRanking.rule_list
# >> |------------+------+-------------+------+--------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> | key        | name | o_count_max | code | ranking_records                                                                                                                                        |
# >> |------------+------+-------------+------+--------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> | xy_rule_1c | 1問  |           1 |    0 | [{:rank=>1, :xy_game_record_id=>"3", :name=>"(name1)", :spent_msec=>59.123}, {:rank=>2, :xy_game_record_id=>"4", :name=>"(name2)", :spent_msec=>60.123}] |
# >> | xy_rule_2c | 2問  |           2 |    1 | [{:rank=>1, :xy_game_record_id=>"3", :name=>"(name1)", :spent_msec=>59.123}, {:rank=>2, :xy_game_record_id=>"4", :name=>"(name2)", :spent_msec=>60.123}] |
# >> |------------+------+-------------+------+--------------------------------------------------------------------------------------------------------------------------------------------------------|
