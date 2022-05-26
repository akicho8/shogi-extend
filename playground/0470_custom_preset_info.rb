#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

tp PresetInfo.as_json

tp Swars::SwPresetInfo.as_json

# >> |----------------+-------+----------+---------------+--------------------------------------+------|
# >> | key            | minor | handicap | special_piece | piece_boxes                          | code |
# >> |----------------+-------+----------+---------------+--------------------------------------+------|
# >> | 平手           | false | false    | true          | {:black=>"", :white=>""}             |    0 |
# >> | 香落ち         | false | true     | true          | {:black=>"", :white=>""}             |    1 |
# >> | 右香落ち       | true  | true     | true          | {:black=>"", :white=>""}             |    2 |
# >> | 角落ち         | false | true     | false         | {:black=>"", :white=>""}             |    3 |
# >> | 飛車落ち       | false | true     | false         | {:black=>"", :white=>""}             |    4 |
# >> | 飛香落ち       | false | true     | false         | {:black=>"", :white=>""}             |    5 |
# >> | 二枚落ち       | false | true     | false         | {:black=>"", :white=>""}             |    6 |
# >> | 二枚持ち       | true  | true     | false         | {:black=>"飛角", :white=>""}         |    7 |
# >> | 三枚落ち       | false | true     | false         | {:black=>"", :white=>""}             |    8 |
# >> | 四枚落ち       | false | true     | false         | {:black=>"", :white=>""}             |    9 |
# >> | 六枚落ち       | false | true     | false         | {:black=>"", :white=>""}             |   10 |
# >> | トンボ         | true  | true     | true          | {:black=>"", :white=>""}             |   11 |
# >> | 八枚落ち       | false | true     | false         | {:black=>"", :white=>""}             |   12 |
# >> | 十枚落ち       | false | true     | false         | {:black=>"", :white=>""}             |   13 |
# >> | 十九枚落ち     | true  | true     | false         | {:black=>"", :white=>""}             |   14 |
# >> | 二十枚落ち     | true  | true     | false         | {:black=>"", :white=>""}             |   15 |
# >> | 青空将棋       | true  | false    | true          | {:black=>"", :white=>""}             |   16 |
# >> | バリケード将棋 | true  | false    | true          | {:black=>"飛角香", :white=>"飛角香"} |   17 |
# >> | 5五将棋        | true  | false    | true          | {:black=>"", :white=>""}             |   18 |
# >> |----------------+-------+----------+---------------+--------------------------------------+------|
# >> |----------+------|
# >> | key      | code |
# >> |----------+------|
# >> | 平手     |    0 |
# >> | 角落ち   |    1 |
# >> | 飛車落ち |    2 |
# >> | 二枚落ち |    3 |
# >> | 四枚落ち |    4 |
# >> | 六枚落ち |    5 |
# >> | 八枚落ち |    6 |
# >> |----------+------|
