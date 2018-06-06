#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

tp LifetimeInfo.as_json
tp LifetimeInfo.as_hash_json

# >> |-----------------+------------+---------------+---------+------|
# >> | key             | name       | limit_seconds | byoyomi | code |
# >> |-----------------+------------+---------------+---------+------|
# >> | lifetime_m10  | 10分       |           600 |       0 |    0 |
# >> | lifetime_m5   | 5分        |           300 |       0 |    1 |
# >> | lifetime_m3   | 3分        |           180 |       0 |    2 |
# >> | lifetime_m3   | 3秒        |             3 |       0 |    3 |
# >> | lifetime_m0_b0   | 0秒        |             0 |       0 |    4 |
# >> | lifetime_m0_b10 | 3秒 + 10秒 |             3 |      10 |    5 |
# >> |-----------------+------------+---------------+---------+------|
# >> |-----------------+------------------------------------------------------------------------------------------------|
# >> |  lifetime_m10 | {"key"=>"lifetime_m10", "name"=>"10分", "limit_seconds"=>600, "byoyomi"=>0, "code"=>0}       |
# >> |   lifetime_m5 | {"key"=>"lifetime_m5", "name"=>"5分", "limit_seconds"=>300, "byoyomi"=>0, "code"=>1}         |
# >> |   lifetime_m3 | {"key"=>"lifetime_m3", "name"=>"3分", "limit_seconds"=>180, "byoyomi"=>0, "code"=>2}         |
# >> |   lifetime_m3 | {"key"=>"lifetime_m3", "name"=>"3秒", "limit_seconds"=>3, "byoyomi"=>0, "code"=>3}           |
# >> |   lifetime_m0_b0 | {"key"=>"lifetime_m0_b0", "name"=>"0秒", "limit_seconds"=>0, "byoyomi"=>0, "code"=>4}           |
# >> | lifetime_m0_b10 | {"key"=>"lifetime_m0_b10", "name"=>"3秒 + 10秒", "limit_seconds"=>3, "byoyomi"=>10, "code"=>5} |
# >> |-----------------+------------------------------------------------------------------------------------------------|
