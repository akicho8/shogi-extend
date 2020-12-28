#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

XyRecord.destroy_all
XyRuleInfo.redis.flushdb

Timecop.freeze("2000-01-01") do
  10.times do
    XyRecord.create!(xy_rule_key: "xy_rule100t", entry_name: "x", spent_sec: 1, x_count: 0)
  end
end

10.times do
  XyRecord.create!(xy_rule_key: "xy_rule100t", entry_name: "x", spent_sec: 1, x_count: 0)
end
XyRuleInfo.rebuild

r = XyRecord.create!(xy_rule_key: "xy_rule100t", entry_name: "x", spent_sec: 2, x_count: 0)

r.rank(xy_scope_key: "xy_scope_today", entry_name_uniq_p: "true")    # => 2
r.rank_info                     # => {:xy_scope_today=>{:rank=>11, :page=>1}, :xy_scope_all=>{:rank=>21, :page=>2}}

# XyRecord.create!(xy_rule_key: "xy_rule100t", entry_name: "x", spent_sec: 10, x_count: 0)
# XyRecord.create!(xy_rule_key: "xy_rule100t", entry_name: "x", spent_sec: 20, x_count: 0)
# XyRecord.create!(xy_rule_key: "xy_rule100t", entry_name: "x", spent_sec: 30, x_count: 0)
# XyRecord.create!(xy_rule_key: "xy_rule100t", entry_name: "x", spent_sec: 40, x_count: 0)
# XyRuleInfo.rebuild
#
# XyRecord.last.rank(xy_scope_key: "xy_scope_all", entry_name_uniq_p: "true")    # => 2
#
# tp XyRuleInfo[:xy_rule100t].xy_records(xy_scope_key: "xy_scope_all", entry_name_uniq_p: "true")
# tp XyRuleInfo[:xy_rule100t].xy_records(xy_scope_key: "xy_scope_today", entry_name_uniq_p: "true")
#
tp XyRecord
# >> |------+-------------------+------------+---------+-------------+---------+-----------+---------------------------+---------------------------|
# >> | id   | colosseum_user_id | entry_name | summary | xy_rule_key | x_count | spent_sec | created_at                | updated_at                |
# >> |------+-------------------+------------+---------+-------------+---------+-----------+---------------------------+---------------------------|
# >> | 2964 |                   | x          |         | xy_rule100t |       0 |       1.0 | 2000-01-01 00:00:00 +0900 | 2000-01-01 00:00:00 +0900 |
# >> | 2965 |                   | x          |         | xy_rule100t |       0 |       1.0 | 2000-01-01 00:00:00 +0900 | 2000-01-01 00:00:00 +0900 |
# >> | 2966 |                   | x          |         | xy_rule100t |       0 |       1.0 | 2000-01-01 00:00:00 +0900 | 2000-01-01 00:00:00 +0900 |
# >> | 2967 |                   | x          |         | xy_rule100t |       0 |       1.0 | 2000-01-01 00:00:00 +0900 | 2000-01-01 00:00:00 +0900 |
# >> | 2968 |                   | x          |         | xy_rule100t |       0 |       1.0 | 2000-01-01 00:00:00 +0900 | 2000-01-01 00:00:00 +0900 |
# >> | 2969 |                   | x          |         | xy_rule100t |       0 |       1.0 | 2000-01-01 00:00:00 +0900 | 2000-01-01 00:00:00 +0900 |
# >> | 2970 |                   | x          |         | xy_rule100t |       0 |       1.0 | 2000-01-01 00:00:00 +0900 | 2000-01-01 00:00:00 +0900 |
# >> | 2971 |                   | x          |         | xy_rule100t |       0 |       1.0 | 2000-01-01 00:00:00 +0900 | 2000-01-01 00:00:00 +0900 |
# >> | 2972 |                   | x          |         | xy_rule100t |       0 |       1.0 | 2000-01-01 00:00:00 +0900 | 2000-01-01 00:00:00 +0900 |
# >> | 2973 |                   | x          |         | xy_rule100t |       0 |       1.0 | 2000-01-01 00:00:00 +0900 | 2000-01-01 00:00:00 +0900 |
# >> | 2974 |                   | x          |         | xy_rule100t |       0 |       1.0 | 2020-01-27 20:44:28 +0900 | 2020-01-27 20:44:28 +0900 |
# >> | 2975 |                   | x          |         | xy_rule100t |       0 |       1.0 | 2020-01-27 20:44:28 +0900 | 2020-01-27 20:44:28 +0900 |
# >> | 2976 |                   | x          |         | xy_rule100t |       0 |       1.0 | 2020-01-27 20:44:28 +0900 | 2020-01-27 20:44:28 +0900 |
# >> | 2977 |                   | x          |         | xy_rule100t |       0 |       1.0 | 2020-01-27 20:44:28 +0900 | 2020-01-27 20:44:28 +0900 |
# >> | 2978 |                   | x          |         | xy_rule100t |       0 |       1.0 | 2020-01-27 20:44:28 +0900 | 2020-01-27 20:44:28 +0900 |
# >> | 2979 |                   | x          |         | xy_rule100t |       0 |       1.0 | 2020-01-27 20:44:28 +0900 | 2020-01-27 20:44:28 +0900 |
# >> | 2980 |                   | x          |         | xy_rule100t |       0 |       1.0 | 2020-01-27 20:44:28 +0900 | 2020-01-27 20:44:28 +0900 |
# >> | 2981 |                   | x          |         | xy_rule100t |       0 |       1.0 | 2020-01-27 20:44:28 +0900 | 2020-01-27 20:44:28 +0900 |
# >> | 2982 |                   | x          |         | xy_rule100t |       0 |       1.0 | 2020-01-27 20:44:28 +0900 | 2020-01-27 20:44:28 +0900 |
# >> | 2983 |                   | x          |         | xy_rule100t |       0 |       1.0 | 2020-01-27 20:44:28 +0900 | 2020-01-27 20:44:28 +0900 |
# >> | 2984 |                   | x          |         | xy_rule100t |       0 |       2.0 | 2020-01-27 20:44:29 +0900 | 2020-01-27 20:44:29 +0900 |
# >> |------+-------------------+------------+---------+-------------+---------+-----------+---------------------------+---------------------------|
