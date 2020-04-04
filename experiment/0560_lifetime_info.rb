#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

tp Colosseum::LifetimeInfo.as_json

# >> ["/Users/ikeda/src/shogi_web/config/initializers/0180_active_model_serializers.rb:11", nil, :ams_sr]
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
