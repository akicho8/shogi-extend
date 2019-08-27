#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

# XyRuleInfo.clear_all
#
# XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "(name1)", spent_sec: 1.123, x_count: 0)
# XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "(name1)", spent_sec: 2.123, x_count: 0)
# XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "(name1)", spent_sec: 3.123, x_count: 0)

XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "(name1)", spent_sec: 1.1233, x_count: 0)
XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "(name1)", spent_sec: 1.1233, x_count: 0)
XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "(name1)", spent_sec: 1.1234, x_count: 0)
XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "(name1)", spent_sec: 1.1234, x_count: 0)
XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "(name1)", spent_sec: 1.1235, x_count: 0)
XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "(name1)", spent_sec: 1.1235, x_count: 0)

#
# tp XyRecord.all.collect { |e| {id: e.id, page: e.ranking_page } }
#
# tp XyRuleInfo.rule_list
#
# tp XyRuleInfo[:xy_rule1].xy_records

tp XyRecord

# >> |----+-------------------+------------+------------------------------------------------------------+-------------+---------+-----------+---------------------------+---------------------------|
# >> | id | colosseum_user_id | entry_name | summary                                                    | xy_rule_key | x_count | spent_sec | created_at                | updated_at                |
# >> |----+-------------------+------------+------------------------------------------------------------+-------------+---------+-----------+---------------------------+---------------------------|
# >> |  1 |                 1 | 運営       | ルール: 100問 タイム: 00:04.282 まちがえた数: 0 正解率: 0% | xy_rule100  |       0 |   4.28207 | 2019-08-27 11:58:22 +0900 | 2019-08-27 11:58:24 +0900 |
# >> |  2 |                   | (name1)    |                                                            | xy_rule1    |       0 |    1.1233 | 2019-08-27 14:04:14 +0900 | 2019-08-27 14:04:14 +0900 |
# >> |  3 |                   | (name1)    |                                                            | xy_rule1    |       0 |    1.1233 | 2019-08-27 14:04:14 +0900 | 2019-08-27 14:04:14 +0900 |
# >> |  4 |                   | (name1)    |                                                            | xy_rule1    |       0 |    1.1234 | 2019-08-27 14:04:14 +0900 | 2019-08-27 14:04:14 +0900 |
# >> |  5 |                   | (name1)    |                                                            | xy_rule1    |       0 |    1.1234 | 2019-08-27 14:04:14 +0900 | 2019-08-27 14:04:14 +0900 |
# >> |  6 |                   | (name1)    |                                                            | xy_rule1    |       0 |    1.1235 | 2019-08-27 14:04:14 +0900 | 2019-08-27 14:04:14 +0900 |
# >> |  7 |                   | (name1)    |                                                            | xy_rule1    |       0 |    1.1235 | 2019-08-27 14:04:14 +0900 | 2019-08-27 14:04:14 +0900 |
# >> |----+-------------------+------------+------------------------------------------------------------+-------------+---------+-----------+---------------------------+---------------------------|
