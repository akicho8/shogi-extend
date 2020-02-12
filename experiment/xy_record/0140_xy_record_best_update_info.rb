#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

XyRecord.destroy_all
XyRuleInfo.redis.flushdb

XyRecord.create!(xy_rule_key: "xy_rule100t", entry_name: "x", spent_sec: 10,  x_count: 0).best_update_info # => nil
XyRecord.create!(xy_rule_key: "xy_rule100t", entry_name: "x", spent_sec: 10,  x_count: 0).best_update_info # => nil
XyRecord.create!(xy_rule_key: "xy_rule100t", entry_name: "x", spent_sec: 9.9, x_count: 0).best_update_info # => {:updated_spent_sec=>0.099}

tp XyRecord
# >> |----+-------------------+------------+---------+-------------+---------+-----------+---------------------------+---------------------------|
# >> | id | colosseum_user_id | entry_name | summary | xy_rule_key | x_count | spent_sec | created_at                | updated_at                |
# >> |----+-------------------+------------+---------+-------------+---------+-----------+---------------------------+---------------------------|
# >> | 52 |                   | x          |         | xy_rule100t |       0 |      10.0 | 2020-02-12 13:52:06 +0900 | 2020-02-12 13:52:06 +0900 |
# >> | 53 |                   | x          |         | xy_rule100t |       0 |      10.0 | 2020-02-12 13:52:06 +0900 | 2020-02-12 13:52:06 +0900 |
# >> | 54 |                   | x          |         | xy_rule100t |       0 |       9.9 | 2020-02-12 13:52:06 +0900 | 2020-02-12 13:52:06 +0900 |
# >> |----+-------------------+------------+---------+-------------+---------+-----------+---------------------------+---------------------------|
