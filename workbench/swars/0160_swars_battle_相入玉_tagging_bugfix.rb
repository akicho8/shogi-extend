#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

module Swars
  Battle.destroy_all

  ENV["RUN_REMOTE"] = "true"
  Battle.find_by(key: "Yosikawakun-soybean-20190226_095952")&.destroy
  Importer::BattleImporter.new(key: BattleKey["Yosikawakun-soybean-20190226_095952"]).call
  battle = Battle.last

  battle.note_tag_list     # => []
  battle.other_tag_list     # => []
  battle.memberships[0].reload.note_tag_list # => ["居飛車", "入玉", "相入玉"]
  battle.memberships[1].reload.note_tag_list # => ["居飛車", "入玉", "相入玉"]

  tp ActsAsTaggableOn::Tag.find_by(name: "入玉").taggings

  # tp Battle.last
end
# >> [fetch][record] https://shogiwars.heroz.jp/games/Yosikawakun-soybean-20190226_095952?locale=ja
# >> |-----+--------+-------------------+-------------+-------------+-----------+-----------+---------------------------|
# >> | id  | tag_id | taggable_type     | taggable_id | tagger_type | tagger_id | context   | created_at                |
# >> |-----+--------+-------------------+-------------+-------------+-----------+-----------+---------------------------|
# >> | 330 |     35 | Swars::Membership |         125 |             |           | note_tags | 2023-09-16 13:27:32 +0900 |
# >> | 334 |     35 | Swars::Membership |         126 |             |           | note_tags | 2023-09-16 13:27:32 +0900 |
# >> |-----+--------+-------------------+-------------+-------------+-----------+-----------+---------------------------|
