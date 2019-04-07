#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

module Swars
  Battle.destroy_all

  ENV["RUN_REMOTE"] = "1"
  Battle.find_by(key: "Yosikawakun-soybean-20190226_095952")&.destroy
  Battle.single_battle_import(key: "Yosikawakun-soybean-20190226_095952")
  battle = Battle.last

  battle.note_tag_list     # => ["入玉", "相入玉", "指導対局"]
  battle.other_tag_list     # => ["将棋ウォーズ(3分切れ負け)", "00:03+00", "Yosikawakun", "六段", "soybean", "五段", "2019", "2", "26", "2019/02", "2019/02/26", "211", "3分", "入玉"]
  battle.memberships[0].reload.note_tag_list # => ["入玉", "相入玉"]
  battle.memberships[1].reload.note_tag_list # => ["入玉", "相入玉", "指導対局"]

  tp ActsAsTaggableOn::Tag.find_by(name: "入玉").taggings

  # user1.tactic_summary_for(:note) # =>
  # user2.tactic_summary_for(:note) # =>
  #
  # tp Battle.last
end
# >> |------+--------+-------------------+-------------+-------------+-----------+------------+---------------------------|
# >> | id   | tag_id | taggable_type     | taggable_id | tagger_type | tagger_id | context    | created_at                |
# >> |------+--------+-------------------+-------------+-------------+-----------+------------+---------------------------|
# >> | 1667 |    338 | Swars::Battle     |          52 |             |           | note_tags  | 2019-03-21 21:49:56 +0900 |
# >> | 1683 |    338 | Swars::Battle     |          52 |             |           | other_tags | 2019-03-21 21:49:56 +0900 |
# >> | 1657 |    338 | Swars::Membership |         103 |             |           | note_tags  | 2019-03-21 21:49:56 +0900 |
# >> | 1661 |    338 | Swars::Membership |         104 |             |           | note_tags  | 2019-03-21 21:49:56 +0900 |
# >> |------+--------+-------------------+-------------+-------------+-----------+------------+---------------------------|
