#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

tp Bioshogi::PresetInfo.as_json

tp CustomPresetInfo.as_json

# >> |------------+----------+------|
# >> | key        | handicap | code |
# >> |------------+----------+------|
# >> | 平手       | false    |    0 |
# >> | 香落ち     | true     |    1 |
# >> | 右香落ち   | true     |    2 |
# >> | 角落ち     | true     |    3 |
# >> | 飛車落ち   | true     |    4 |
# >> | 飛香落ち   | true     |    5 |
# >> | 二枚落ち   | true     |    6 |
# >> | 三枚落ち   | true     |    7 |
# >> | 四枚落ち   | true     |    8 |
# >> | 六枚落ち   | true     |    9 |
# >> | 八枚落ち   | true     |   10 |
# >> | 十枚落ち   | true     |   11 |
# >> | 十九枚落ち | true     |   12 |
# >> | 二十枚落ち | true     |   13 |
# >> |------------+----------+------|
# >> |----------+----------+------|
# >> | key      | handicap | code |
# >> |----------+----------+------|
# >> | 平手     | false    |    0 |
# >> | 二枚落ち | true     |    6 |
# >> |----------+----------+------|
