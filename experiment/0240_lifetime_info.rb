#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

tp LifetimeInfo.as_json
tp LifetimeInfo.as_hash_json

# >> |-----------------+----------+---------------+---------+------|
# >> | key             | name     | limit_seconds | byoyomi | code |
# >> |-----------------+----------+---------------+---------+------|
# >> | lifetime_m10    | 10分     |           600 |       3 |    0 |
# >> | lifetime_m5     | 5分      |           300 |       3 |    1 |
# >> | lifetime_m3     | 3分      |           180 |       3 |    2 |
# >> | lifetime_p10    | +10秒    |             0 |      10 |    3 |
# >> | lifetime_s0     | 0秒      |             0 |       0 |    4 |
# >> | lifetime_s3     | 3秒      |             3 |       0 |    5 |
# >> | lifetime_s3_p10 | 3秒+10秒 |             3 |      10 |    6 |
# >> |-----------------+----------+---------------+---------+------|
# >> |-----------------+----------------------------------------------------------------------------------------------|
# >> |    lifetime_m10 | {"key"=>"lifetime_m10", "name"=>"10分", "limit_seconds"=>600, "byoyomi"=>3, "code"=>0}       |
# >> |     lifetime_m5 | {"key"=>"lifetime_m5", "name"=>"5分", "limit_seconds"=>300, "byoyomi"=>3, "code"=>1}         |
# >> |     lifetime_m3 | {"key"=>"lifetime_m3", "name"=>"3分", "limit_seconds"=>180, "byoyomi"=>3, "code"=>2}         |
# >> |    lifetime_p10 | {"key"=>"lifetime_p10", "name"=>"+10秒", "limit_seconds"=>0, "byoyomi"=>10, "code"=>3}       |
# >> |     lifetime_s0 | {"key"=>"lifetime_s0", "name"=>"0秒", "limit_seconds"=>0, "byoyomi"=>0, "code"=>4}           |
# >> |     lifetime_s3 | {"key"=>"lifetime_s3", "name"=>"3秒", "limit_seconds"=>3, "byoyomi"=>0, "code"=>5}           |
# >> | lifetime_s3_p10 | {"key"=>"lifetime_s3_p10", "name"=>"3秒+10秒", "limit_seconds"=>3, "byoyomi"=>10, "code"=>6} |
# >> |-----------------+----------------------------------------------------------------------------------------------|
