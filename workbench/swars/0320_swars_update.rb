#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

user1 = Swars::User.create!
user2 = Swars::User.create!
battle = Swars::Battle.create! do |e|
  e.memberships.build(user: user1)
  e.memberships.build(user: user2)
end

tp battle
tp battle.memberships
# >> |--------------------+--------------------------------------------------------------------------------------------|
# >> |                 id | 32                                                                                         |
# >> |                key | battle4                                                                                    |
# >> |         battled_at | 2021-05-23 17:29:59 +0900                                                                  |
# >> |           rule_key | ten_min                                                                                    |
# >> |            csa_seq | [["+7968GI", 599], ["-8232HI", 597], ["+5756FU", 594], ["-3334FU", 590], ["+6857GI", 592]] |
# >> |          final_key | TORYO                                                                                      |
# >> |        win_user_id | 40                                                                                         |
# >> |           turn_max | 5                                                                                          |
# >> |          meta_info | {}                                                                                         |
# >> |        accessed_at | 2021-05-23 17:29:59 +0900                                                                  |
# >> |         preset_key | 平手                                                                                       |
# >> |          sfen_body | position startpos moves 7i6h 8b3b 5g5f 3c3d 6h5g                                           |
# >> |          sfen_hash | 3867ed2691237d42c7df0bd43fbb5661                                                           |
# >> |         start_turn |                                                                                            |
# >> |      critical_turn |                                                                                            |
# >> |      outbreak_turn |                                                                                            |
# >> |         image_turn |                                                                                            |
# >> |         created_at | 2021-05-23 17:29:59 +0900                                                                  |
# >> |         updated_at | 2021-05-23 17:29:59 +0900                                                                  |
# >> |   defense_tag_list |                                                                                            |
# >> |    attack_tag_list |                                                                                            |
# >> | technique_tag_list |                                                                                            |
# >> |      note_tag_list |                                                                                            |
# >> |     other_tag_list |                                                                                            |
# >> |--------------------+--------------------------------------------------------------------------------------------|
# >> |----+-----------+---------+------------+----------+-----------+--------------+----------+------------+---------------------------+---------------------------+---------------+---------------+----------------+------------+-----------+----------------+-----------------+------------+------------------+-------------------+--------------------+---------------+----------------|
# >> | id | battle_id | user_id | op_user_id | grade_id | judge_key | location_key | position | grade_diff | created_at                | updated_at                | think_all_avg | think_end_avg | two_serial_max | think_last | think_max | think_all_avg2 | two_serial_max2 | think_max2 | defense_tag_list | attack_tag_list   | technique_tag_list | note_tag_list | other_tag_list |
# >> |----+-----------+---------+------------+----------+-----------+--------------+----------+------------+---------------------------+---------------------------+---------------+---------------+----------------+------------+-----------+----------------+-----------------+------------+------------------+-------------------+--------------------+---------------+----------------|
# >> | 63 |        32 |      40 |         41 |       40 | win       | black        |        0 |          0 | 2021-05-23 17:29:59 +0900 | 2021-05-23 17:29:59 +0900 |             2 |             2 |              1 |          2 |         5 |                |                 |            |                  | 嬉野流            |                    | 居飛車        |                |
# >> | 64 |        32 |      41 |         40 |       40 | lose      | white        |        1 |          0 | 2021-05-23 17:29:59 +0900 | 2021-05-23 17:29:59 +0900 |             5 |             5 |                |          7 |         7 |                |                 |            |                  | 2手目△3ニ飛戦法 |                    | 振り飛車      |                |
# >> |----+-----------+---------+------------+----------+-----------+--------------+----------+------------+---------------------------+---------------------------+---------------+---------------+----------------+------------+-----------+----------------+-----------------+------------+------------------+-------------------+--------------------+---------------+----------------|
