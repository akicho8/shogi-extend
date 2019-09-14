#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

XyRecord.destroy_all
XyRuleInfo.rebuild

# XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "(name1)", spent_sec: 1.123, x_count: 0)
# XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "(name1)", spent_sec: 2.123, x_count: 0)
# XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "(name1)", spent_sec: 3.123, x_count: 0)

XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "(name1)", spent_sec: 0.785, x_count: 0)
XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "(name1)", spent_sec: 0.784, x_count: 0)
XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "(name2)", spent_sec: 0.783, x_count: 0)
XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "(name2)", spent_sec: 0.782, x_count: 0)

# tp XyRuleInfo[:xy_rule1].xy_records

# tp XyRuleInfo[:xy_rule1].xy_records


# tp XyRecord.all.collect { |e| {id: e.id, page: e.ranking_page } }
# tp XyRuleInfo.rule_list
# tp XyRuleInfo[:xy_rule1].xy_records
tp XyRecord

# >> |----+-------------------+------------+---------+-------------+---------+-----------+---------------------------+---------------------------|
# >> | id | colosseum_user_id | entry_name | summary | xy_rule_key | x_count | spent_sec | created_at                | updated_at                |
# >> |----+-------------------+------------+---------+-------------+---------+-----------+---------------------------+---------------------------|
# >> | 51 |                   | (name1)    |         | xy_rule1    |       0 |     0.785 | 2019-09-14 13:09:03 +0900 | 2019-09-14 13:09:03 +0900 |
# >> | 52 |                   | (name1)    |         | xy_rule1    |       0 |     0.784 | 2019-09-14 13:09:03 +0900 | 2019-09-14 13:09:03 +0900 |
# >> | 53 |                   | (name2)    |         | xy_rule1    |       0 |     0.783 | 2019-09-14 13:09:03 +0900 | 2019-09-14 13:09:03 +0900 |
# >> | 54 |                   | (name2)    |         | xy_rule1    |       0 |     0.782 | 2019-09-14 13:09:03 +0900 | 2019-09-14 13:09:03 +0900 |
# >> |----+-------------------+------------+---------+-------------+---------+-----------+---------------------------+---------------------------|
