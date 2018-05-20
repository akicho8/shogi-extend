#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

tp LifetimeInfo.as_json
tp LifetimeInfo.as_hash_json

# >> |----------------+------+---------------+------|
# >> | key            | name | limit_seconds | code |
# >> |----------------+------+---------------+------|
# >> | lifetime15_min | 15分 |           900 |    0 |
# >> | lifetime10_min | 10分 |           600 |    1 |
# >> | lifetime5_min  | 5分  |           300 |    2 |
# >> | lifetime3_min  | 3分  |           180 |    3 |
# >> | lifetime3_sec  | 3秒  |             3 |    4 |
# >> | lifetime0_sec  | 0秒  |             0 |    5 |
# >> |----------------+------+---------------+------|
# >> |----------------+----------------------------------------------------------------------------|
# >> | lifetime15_min | {"key"=>"lifetime15_min", "name"=>"15分", "limit_seconds"=>900, "code"=>0} |
# >> | lifetime10_min | {"key"=>"lifetime10_min", "name"=>"10分", "limit_seconds"=>600, "code"=>1} |
# >> |  lifetime5_min | {"key"=>"lifetime5_min", "name"=>"5分", "limit_seconds"=>300, "code"=>2}   |
# >> |  lifetime3_min | {"key"=>"lifetime3_min", "name"=>"3分", "limit_seconds"=>180, "code"=>3}   |
# >> |  lifetime3_sec | {"key"=>"lifetime3_sec", "name"=>"3秒", "limit_seconds"=>3, "code"=>4}     |
# >> |  lifetime0_sec | {"key"=>"lifetime0_sec", "name"=>"0秒", "limit_seconds"=>0, "code"=>5}     |
# >> |----------------+----------------------------------------------------------------------------|
