#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

user = Swars::User.find_by!(user_key: "kinakom0chi")
tp user.grade.grade_info
tp user.battles.last.memberships # => #<ActiveRecord::Associations::CollectionProxy [#<Swars::Membership id: 83, battle_id: 42, user_id: 26, grade_id: 12, judge_key: "lose", location_key: "black", position: 0, created_at: "2019-04-07 10:04:58", updated_at: "2019-04-07 10:04:58", defense_tag_list: nil, attack_tag_list: nil, technique_tag_list: nil, note_tag_list: nil>, #<Swars::Membership id: 84, battle_id: 42, user_id: 45, grade_id: 1, judge_key: "win", location_key: "white", position: 1, created_at: "2019-04-07 10:04:58", updated_at: "2019-04-07 10:04:58", defense_tag_list: nil, attack_tag_list: nil, technique_tag_list: nil, note_tag_list: nil>]>
# >> |------+------|
# >> |  key | 十段 |
# >> | code | 0    |
# >> |------+------|
# >> |----+-----------+---------+----------+-----------+--------------+----------+---------------------------+---------------------------+------------------+-----------------+--------------------+---------------|
# >> | id | battle_id | user_id | grade_id | judge_key | location_key | position | created_at                | updated_at                | defense_tag_list | attack_tag_list | technique_tag_list | note_tag_list |
# >> |----+-----------+---------+----------+-----------+--------------+----------+---------------------------+---------------------------+------------------+-----------------+--------------------+---------------|
# >> | 83 |        42 |      26 |       12 | lose      | black        |        0 | 2019-04-07 19:04:58 +0900 | 2019-04-07 19:04:58 +0900 |                  |                 |                    |               |
# >> | 84 |        42 |      45 |        1 | win       | white        |        1 | 2019-04-07 19:04:58 +0900 | 2019-04-07 19:04:58 +0900 |                  |                 |                    |               |
# >> |----+-----------+---------+----------+-----------+--------------+----------+---------------------------+---------------------------+------------------+-----------------+--------------------+---------------|
