#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

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
#   tp XyRuleInfo[:xy_rule1].xy_records(xy_scope_key: "xy_scope_all", entry_name_uniq_p: "false")
#   tp XyRuleInfo[:xy_rule1].xy_records(xy_scope_key: "xy_scope_all", entry_name_uniq_p: "true")
#   tp XyRuleInfo[:xy_rule1].xy_records(xy_scope_key: "xy_scope_today", entry_name_uniq_p: "false")
#   tp XyRuleInfo[:xy_rule1].xy_records(xy_scope_key: "xy_scope_today", entry_name_uniq_p: "true")
# end

# tp XyRecord.select("*").where(entry_name: "きなこもち").where(xy_rule_key: "xy_rule100").group("date(created_at)")

# XyRecord.where(XyRecord.arel_table[:created_at].gteq(Time.current.midnight)).group(:entry_name).count.keys # => ["shaq", "あ", "お財布いっぱいクイズQQQのQ", "ひゃくねん", "よう", "荒巻スカルチノフ"]
# exit


scope = XyRecord.all
scope = scope.where(xy_rule_key: "xy_rule100")
scope.group("entry_name").order("count_all desc").having("count_all >= 10").count # => {"きなこもち"=>630, "ひゃくねん"=>327, "saburo"=>17, "aaa"=>11}

names = scope.group("entry_name").pluck("entry_name") # => [".", "1", "aaa", "akihikotakamura", "ASAI", "asanootoko", "asshole", "e", "jsch", "k", "mikk", "mituba", "oppp", "rem", "saburo", "skurima", "tt", "wat", "あ", "きなこもち", "ひゃくねん", "びわのたね", "よう", "ろどりげす", "名無しの棋士60号", "名無しの棋士81号", "疲れた", "雪風"]
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
# >> | .                | [{"x"=>"2020-01-24", "y"=>277.194}]                                                                                                                                                                                                                                 |
# >> |                1 | [{"x"=>"2020-01-23", "y"=>215.283}]                                                                                                                                                                                                                                 |
# >> | aaa              | [{"x"=>"2020-01-24", "y"=>176.527}]                                                                                                                                                                                                                                 |
# >> | akihikotakamura  | [{"x"=>"2020-01-23", "y"=>303.921}]                                                                                                                                                                                                                                 |
# >> | ASAI             | [{"x"=>"2020-01-19", "y"=>236.392}]                                                                                                                                                                                                                                 |
# >> | asanootoko       | [{"x"=>"2019-10-16", "y"=>244.33}]                                                                                                                                                                                                                                  |
# >> | asshole          | [{"x"=>"2020-01-24", "y"=>333.458}]                                                                                                                                                                                                                                 |
# >> | e                | [{"x"=>"2020-02-04", "y"=>215.772}]                                                                                                                                                                                                                                 |
# >> | jsch             | [{"x"=>"2020-02-04", "y"=>137.606}]                                                                                                                                                                                                                                 |
# >> | k                | [{"x"=>"2019-09-23", "y"=>316.591}]                                                                                                                                                                                                                                 |
# >> | mikk             | [{"x"=>"2020-01-28", "y"=>236.716}]                                                                                                                                                                                                                                 |
# >> | mituba           | [{"x"=>"2020-01-21", "y"=>259.67}]                                                                                                                                                                                                                                  |
# >> | oppp             | [{"x"=>"2020-01-24", "y"=>207.733}]                                                                                                                                                                                                                                 |
# >> | rem              | [{"x"=>"2020-01-24", "y"=>307.513}]                                                                                                                                                                                                                                 |
# >> | saburo           | [{"x"=>"2020-02-06", "y"=>255.221}, {"x"=>"2020-02-07", "y"=>149.685}, {"x"=>"2020-02-08", "y"=>151.386}, {"x"=>"2020-02-09", "y"=>156.219}, {"x"=>"2020-02-10", "y"=>159.903}, {"x"=>"2020-02-11", "y"=>156.469}]                                                  |
# >> | skurima          | [{"x"=>"2020-02-02", "y"=>250.633}]                                                                                                                                                                                                                                 |
# >> | tt               | [{"x"=>"2020-01-18", "y"=>360.361}]                                                                                                                                                                                                                                 |
# >> | wat              | [{"x"=>"2020-01-28", "y"=>234.525}]                                                                                                                                                                                                                                 |
# >> | あ               | [{"x"=>"2020-02-03", "y"=>205.109}]                                                                                                                                                                                                                                 |
# >> | きなこもち       | [{"x"=>"2019-08-10", "y"=>171.772}, {"x"=>"2019-08-11", "y"=>161.548}, {"x"=>"2019-08-12", "y"=>157.918}, {"x"=>"2019-08-13", "y"=>146.687}, {"x"=>"2019-08-14", "y"=>142.752}, {"x"=>"2019-08-15", "y"=>139.364}, {"x"=>"2019-08-16", "y"=>133.889}, {"x"=>"201... |
# >> | ひゃくねん       | [{"x"=>"2019-08-27", "y"=>112.651}, {"x"=>"2019-08-29", "y"=>107.578}, {"x"=>"2019-08-30", "y"=>107.411}, {"x"=>"2019-08-31", "y"=>104.074}, {"x"=>"2019-09-01", "y"=>102.105}, {"x"=>"2019-09-02", "y"=>100.169}, {"x"=>"2019-09-03", "y"=>99.884}, {"x"=>"2019... |
# >> | びわのたね       | [{"x"=>"2019-08-13", "y"=>203.426}]                                                                                                                                                                                                                                 |
# >> | よう             | [{"x"=>"2020-01-27", "y"=>365.397}]                                                                                                                                                                                                                                 |
# >> | ろどりげす       | [{"x"=>"2020-02-02", "y"=>322.885}]                                                                                                                                                                                                                                 |
# >> | 名無しの棋士60号 | [{"x"=>"2019-08-27", "y"=>367.679}]                                                                                                                                                                                                                                 |
# >> | 名無しの棋士81号 | [{"x"=>"2020-02-09", "y"=>89.749}]                                                                                                                                                                                                                                  |
# >> | 疲れた           | [{"x"=>"2020-01-28", "y"=>263.097}]                                                                                                                                                                                                                                 |
# >> | 雪風             | [{"x"=>"2020-01-22", "y"=>220.462}]                                                                                                                                                                                                                                 |
# >> |------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
