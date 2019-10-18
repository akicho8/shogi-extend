#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

# XyRecord.destroy_all
#
# Timecop.freeze("2000-01-01") do
#   XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "a", spent_sec: 0.1, x_count: 0)
#   XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "b", spent_sec: 0.1, x_count: 0)
# end
#
# Timecop.freeze("2000-01-02") do
#   XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "a", spent_sec: 0.2, x_count: 0)
#   XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "a", spent_sec: 0.3, x_count: 0)
#   XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "b", spent_sec: 0.2, x_count: 0)
#   XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "b", spent_sec: 0.3, x_count: 0)
#
#   XyRuleInfo.redis.flushdb
#   XyRuleInfo[:xy_rule1].aggregate
#
#   tp XyRuleInfo[:xy_rule1].xy_records(xy_scope_key: "xy_scope_all", entry_name_unique: "false")
#   tp XyRuleInfo[:xy_rule1].xy_records(xy_scope_key: "xy_scope_all", entry_name_unique: "true")
#   tp XyRuleInfo[:xy_rule1].xy_records(xy_scope_key: "xy_scope_today", entry_name_unique: "false")
#   tp XyRuleInfo[:xy_rule1].xy_records(xy_scope_key: "xy_scope_today", entry_name_unique: "true")
# end

# tp XyRecord.select("*").where(entry_name: "きなこもち").where(xy_rule_key: "xy_rule100").group("date(created_at)")

scope = XyRecord.all
scope = scope.where(xy_rule_key: "xy_rule100")
scope.group("entry_name").order("count_all desc").having("count_all >= 10").count # => {"きなこもち"=>503, "ひゃくねん"=>314}

names = scope.group("entry_name").pluck("entry_name") # => ["k", "きなこもち", "ひゃくねん", "びわのたね", "名無しの棋士60号"]
result = XyRecord.select("entry_name, date(created_at) as created_on, min(spent_sec) as spent_sec").where(xy_rule_key: "xy_rule100").group("entry_name, date(created_at)")
rows = names.collect { |name|
  v = result.find_all { |e| e.entry_name == name }
  unless v.empty?
    {
      name: name,
      data: v.collect { |e| {x: e.created_on, y: e.spent_sec } }.as_json,
    }
  end
}.compact
tp rows

# puts v.to_json
# >> |------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> | name             | data                                                                                                                                                                                                                                                                |
# >> |------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> | k                | [{"x"=>"2019-09-23", "y"=>316.591}]                                                                                                                                                                                                                                 |
# >> | きなこもち       | [{"x"=>"2019-08-10", "y"=>171.772}, {"x"=>"2019-08-11", "y"=>161.548}, {"x"=>"2019-08-12", "y"=>157.918}, {"x"=>"2019-08-13", "y"=>146.687}, {"x"=>"2019-08-14", "y"=>142.752}, {"x"=>"2019-08-15", "y"=>139.364}, {"x"=>"2019-08-16", "y"=>133.889}, {"x"=>"201... |
# >> | ひゃくねん       | [{"x"=>"2019-08-27", "y"=>112.651}, {"x"=>"2019-08-29", "y"=>107.578}, {"x"=>"2019-08-30", "y"=>107.411}, {"x"=>"2019-08-31", "y"=>104.074}, {"x"=>"2019-09-01", "y"=>102.105}, {"x"=>"2019-09-02", "y"=>100.169}, {"x"=>"2019-09-03", "y"=>99.884}, {"x"=>"2019... |
# >> | びわのたね       | [{"x"=>"2019-08-13", "y"=>203.426}]                                                                                                                                                                                                                                 |
# >> | 名無しの棋士60号 | [{"x"=>"2019-08-27", "y"=>367.679}]                                                                                                                                                                                                                                 |
# >> |------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
