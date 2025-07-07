#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

tp PresetInfo.as_json

tp Swars::SwPresetInfo.as_json

# >> |----------------+-------+----------+-------------+---------+------------------------------------+------|
# >> | key            | major | handicap | hirate_like | x_taden | piece_boxes                        | code |
# >> |----------------+-------+----------+-------------+---------+------------------------------------+------|
# >> | 平手           | true  | false    | true        | true    | {black: "", white: ""}             |    0 |
# >> | 香落ち         | true  | true     | true        | true    | {black: "", white: ""}             |    1 |
# >> | 右香落ち       | false | true     | true        | true    | {black: "", white: ""}             |    2 |
# >> | 角落ち         | true  | true     | false       | true    | {black: "", white: ""}             |    3 |
# >> | 飛車落ち       | true  | true     | false       | true    | {black: "", white: ""}             |    4 |
# >> | 飛香落ち       | true  | true     | false       | true    | {black: "", white: ""}             |    5 |
# >> | 二枚落ち       | true  | true     | false       | true    | {black: "", white: ""}             |    6 |
# >> | 二枚持ち       | false | true     | false       | true    | {black: "飛角", white: ""}         |    7 |
# >> | 三枚落ち       | true  | true     | false       | true    | {black: "", white: ""}             |    8 |
# >> | 四枚落ち       | true  | true     | false       | true    | {black: "", white: ""}             |    9 |
# >> | 六枚落ち       | true  | true     | false       | true    | {black: "", white: ""}             |   10 |
# >> | トンボ         | false | true     | false       | false   | {black: "", white: ""}             |   11 |
# >> | 八枚落ち       | true  | true     | false       | false   | {black: "", white: ""}             |   12 |
# >> | 十枚落ち       | true  | true     | false       | false   | {black: "", white: ""}             |   13 |
# >> | 十九枚落ち     | false | true     | false       | false   | {black: "", white: ""}             |   14 |
# >> | 二十枚落ち     | false | true     | false       | false   | {black: "", white: ""}             |   15 |
# >> | 青空将棋       | false | false    | false       | false   | {black: "", white: ""}             |   16 |
# >> | バリケード将棋 | false | false    | false       | false   | {black: "飛角香", white: "飛角香"} |   17 |
# >> | 5五将棋        | false | false    | false       | false   | {black: "", white: ""}             |   18 |
# >> |----------------+-------+----------+-------------+---------+------------------------------------+------|
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
# >> | 十枚落ち |    7 |
# >> |----------+------|
