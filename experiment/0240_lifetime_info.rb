#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

tp LifetimeInfo.as_json
tp LifetimeInfo.as_hash_json

# >> |-----------------+------------+---------------+---------+------|
# >> | key             | name       | limit_seconds | byoyomi | code |
# >> |-----------------+------------+---------------+---------+------|
# >> | lifetime10_min  | 10分       |           600 |       0 |    0 |
# >> | lifetime5_min   | 5分        |           300 |       0 |    1 |
# >> | lifetime3_min   | 3分        |           180 |       0 |    2 |
# >> | lifetime3_sec   | 3秒        |             3 |       0 |    3 |
# >> | lifetime0_sec   | 0秒        |             0 |       0 |    4 |
# >> | lifetime10_kire | 3秒 + 10秒 |             3 |      10 |    5 |
# >> |-----------------+------------+---------------+---------+------|
# >> |-----------------+------------------------------------------------------------------------------------------------|
# >> |  lifetime10_min | {"key"=>"lifetime10_min", "name"=>"10分", "limit_seconds"=>600, "byoyomi"=>0, "code"=>0}       |
# >> |   lifetime5_min | {"key"=>"lifetime5_min", "name"=>"5分", "limit_seconds"=>300, "byoyomi"=>0, "code"=>1}         |
# >> |   lifetime3_min | {"key"=>"lifetime3_min", "name"=>"3分", "limit_seconds"=>180, "byoyomi"=>0, "code"=>2}         |
# >> |   lifetime3_sec | {"key"=>"lifetime3_sec", "name"=>"3秒", "limit_seconds"=>3, "byoyomi"=>0, "code"=>3}           |
# >> |   lifetime0_sec | {"key"=>"lifetime0_sec", "name"=>"0秒", "limit_seconds"=>0, "byoyomi"=>0, "code"=>4}           |
# >> | lifetime10_kire | {"key"=>"lifetime10_kire", "name"=>"3秒 + 10秒", "limit_seconds"=>3, "byoyomi"=>10, "code"=>5} |
# >> |-----------------+------------------------------------------------------------------------------------------------|
