#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

module Swars
  Battle.destroy_all

  ENV["RUN_REMOTE"] = "true"
  Battle.find_by(key: "Yosikawakun-soybean-20190226_095952")&.destroy
  Battle.single_battle_import(key: "Yosikawakun-soybean-20190226_095952")
  battle = Battle.last

  battle.note_tag_list     # => ["居飛車", "入玉", "相入玉", "相居飛車"]
  battle.other_tag_list     # => ["将棋ウォーズ(3分切れ負け)", "00:03+00", "Yosikawakun", "六段", "soybean", "五段", "平手", "3分", "入玉"]
  battle.memberships[0].reload.note_tag_list # => ["居飛車", "入玉", "相入玉", "相居飛車"]
  battle.memberships[1].reload.note_tag_list # => ["居飛車", "入玉", "相入玉", "相居飛車"]

  tp ActsAsTaggableOn::Tag.find_by(name: "入玉").taggings

  # tp Battle.last
end
# >> |------------------------------------------------------------------------------|
# >> | https://shogiwars.heroz.jp/games/Yosikawakun-soybean-20190226_095952?locale=ja |
# >> |------------------------------------------------------------------------------|
# >> |------+--------+-------------------+-------------+-------------+-----------+------------+---------------------------|
# >> | id   | tag_id | taggable_type     | taggable_id | tagger_type | tagger_id | context    | created_at                |
# >> |------+--------+-------------------+-------------+-------------+-----------+------------+---------------------------|
# >> | 3919 |    118 | Swars::Battle     |          35 |             |           | note_tags  | 2020-01-06 10:56:30 +0900 |
# >> | 3930 |    118 | Swars::Battle     |          35 |             |           | other_tags | 2020-01-06 10:56:30 +0900 |
# >> | 3906 |    118 | Swars::Membership |          69 |             |           | note_tags  | 2020-01-06 10:56:30 +0900 |
# >> | 3912 |    118 | Swars::Membership |          70 |             |           | note_tags  | 2020-01-06 10:56:30 +0900 |
# >> | 1291 |    118 | FreeBattle        |         214 |             |           | note_tags  | 2019-12-25 20:01:11 +0900 |
# >> |------+--------+-------------------+-------------+-------------+-----------+------------+---------------------------|
