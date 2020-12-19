#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

XyRuleInfo.redis.flushdb
XyRuleInfo[:xy_rule1].aggregate

tp XyRecord.where(xy_rule_key: "xy_rule1").order(spent_sec: "asc").limit(10).collect { |e| e.attributes.slice("entry_name", "spent_sec").merge(score: e.score, rank: e.rank(xy_scope_key: "xy_scope_all")) }

# # tp XyRuleInfo.xy_records_hash(xy_scope_key: "xy_scope_today", entry_name_uniq_p: "true")
# tp XyRuleInfo[:xy_rule1].xy_records(xy_scope_key: "xy_scope_all", entry_name_uniq_p: "true")
#
# # tp XyRuleInfo.redis.keys
#
list = XyRuleInfo.redis.zrevrange("xy_rule_info/xy_rule1/all/unique", 0, -1, :with_scores => true).collect { |entry_name, score|
  { entry_name: entry_name, score: score, "元スコア": -(score / 1000) }
}
tp list

# >> |------------+-----------+--------+------|
# >> | entry_name | spent_sec | score  | rank |
# >> |------------+-----------+--------+------|
# >> | きなこもち |     0.549 | -549.0 |    1 |
# >> | きなこもち |       0.6 | -600.0 |    2 |
# >> | ひゃくねん |     0.602 | -602.0 |    3 |
# >> | きなこもち |     0.616 | -616.0 |    4 |
# >> | きなこもち |     0.616 | -616.0 |    4 |
# >> | きなこもち |     0.616 | -616.0 |    4 |
# >> | ひゃくねん |     0.617 | -617.0 |    7 |
# >> | きなこもち |     0.633 | -633.0 |    8 |
# >> | ひゃくねん |     0.635 | -635.0 |    9 |
# >> | きなこもち |     0.639 | -639.0 |   10 |
# >> |------------+-----------+--------+------|
# >> |------------------+----------+----------|
# >> | entry_name       | score    | 元スコア |
# >> |------------------+----------+----------|
# >> | きなこもち       |   -549.0 |    0.549 |
# >> | ひゃくねん       |   -602.0 |    0.602 |
# >> | るも             |  -1345.0 |    1.345 |
# >> | 震える飛車       |  -1497.0 |    1.497 |
# >> | なんかんな       |  -1513.0 |    1.513 |
# >> | skurima          |  -1551.0 |    1.551 |
# >> | こうらい         |  -1565.0 |    1.565 |
# >> | びわのたね       |  -1683.0 |    1.683 |
# >> | ｊｂ             |  -2028.0 |    2.028 |
# >> | ろくろべえ       |  -2134.0 |    2.134 |
# >> | 名無しの騎士     |  -2186.0 |    2.186 |
# >> | 各交換四間飛車   |  -2251.0 |    2.251 |
# >> | 名無しの棋士60号 |  -3202.0 |    3.202 |
# >> | 将棋は飲み物     |  -7419.0 |    7.419 |
# >> | ｇｇｒ           | -21330.0 |    21.33 |
# >> |------------------+----------+----------|
