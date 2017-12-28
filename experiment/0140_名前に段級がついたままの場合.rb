#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

GeneralBattleUser.destroy_all
GeneralBattleRecord.destroy_all

general_battle_record = GeneralBattleRecord.create!(kifu_body: <<~EOT)
先手：花村元司五段
後手：阿久津主税
*「花村元司五段」vs「阿久津主税七段」
EOT

tp GeneralBattleUser
# >> |----+------------+---------------------------+---------------------------|
# >> | id | name       | created_at                | updated_at                |
# >> |----+------------+---------------------------+---------------------------|
# >> | 14 | 花村元司   | 2017-12-27 17:48:15 +0900 | 2017-12-27 17:48:15 +0900 |
# >> | 15 | 阿久津主税 | 2017-12-27 17:48:15 +0900 | 2017-12-27 17:48:15 +0900 |
# >> |----+------------+---------------------------+---------------------------|
