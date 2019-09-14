#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

XyRuleInfo.redis.flushdb
XyRuleInfo[:xy_rule100].aggregate

tp XyRecord.where(xy_rule_key: "xy_rule100").order(spent_sec: "asc").limit(10).collect { |e| e.attributes.slice("entry_name", "spent_sec").merge(score: e.score, rank: e.rank(xy_scope_key: "xy_scope_today")) }

# # tp XyRuleInfo.xy_records_hash(xy_scope_key: "xy_scope_today", entry_name_unique: "true")
# tp XyRuleInfo[:xy_rule100].xy_records(xy_scope_key: "xy_scope_all", entry_name_unique: "true")
#
# # tp XyRuleInfo.redis.keys
#
list = XyRuleInfo.redis.zrevrange("xy_rule_info/xy_rule100/20190914/unique", 0, -1, :with_scores => true).collect { |entry_name, score|
  t = -(score / 1000)
  { entry_name: entry_name, score: score, "元スコア": "%02d:%.3f" % [t / 60, t % 60] }
}
tp list

# >> |------------+-----------+----------+------|
# >> | entry_name | spent_sec | score    | rank |
# >> |------------+-----------+----------+------|
# >> | ひゃくねん |    84.463 | -84463.0 |    1 |
# >> | ひゃくねん |    84.882 | -84882.0 |    2 |
# >> | ひゃくねん |    85.163 | -85163.0 |    2 |
# >> | ひゃくねん |    85.799 | -85799.0 |    2 |
# >> | ひゃくねん |    85.965 | -85965.0 |    2 |
# >> | ひゃくねん |    86.101 | -86101.0 |    2 |
# >> | ひゃくねん |    86.233 | -86233.0 |    2 |
# >> | ひゃくねん |    86.467 | -86467.0 |    3 |
# >> | ひゃくねん |    86.516 | -86516.0 |    3 |
# >> | ひゃくねん |    87.033 | -87033.0 |    4 |
# >> |------------+-----------+----------+------|
# >> |------------+----------+-----------|
# >> | entry_name | score    | 元スコア  |
# >> |------------+----------+-----------|
# >> | ひゃくねん | -84463.0 | 01:24.463 |
# >> | きなこもち | -94081.0 | 01:34.081 |
# >> |------------+----------+-----------|
