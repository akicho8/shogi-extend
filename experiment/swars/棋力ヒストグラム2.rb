require File.expand_path('../../../config/environment', __FILE__)
ApplicationRecord.connection.execute("SET foreign_key_checks = 0")

Swars::Battle.destroy_all
Swars::User.destroy_all

user1 = Swars::User.create!
user2 = Swars::User.create!

create = -> s, n {
  grade = Swars::Grade.fetch(s)
  n.times do
    Swars::Battle.create! do |e|
      e.memberships.build(user: user1, grade: grade)
      e.memberships.build(user: user2, grade: grade)
    end
  end
}

create.call("30級", 1)
create.call("2級", 1)
create.call("1級", 2)
# create.call("初段", 3)
# create.call("二段", 2)
# create.call("三段", 1)

tp Swars::Membership.all

ActiveSupport::LogSubscriber.colorize_logging = false
ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)

# tp Swars::Histogram::Grade.new({}).as_json

s = Swars::Membership.all
s = s.order(id: :desc)
s.in_batches(of: 2, order: :desc) { |e|
  p e
  # tp e.collect(&:attributes)
}

# counts = Swars::Membership.where(id: ids).group(:grade).count

# tp counts

# tp Swars::Membership.tagged_with("")
# tp Swars::Membership.tag_counts_on(:attack_tags)

# tp Swars::User
# tp Swars::Membership

# >> |-----+-----------+---------+------------+----------+-----------+--------------+----------+------------+---------------------------+---------------------------+---------------+---------------+----------------+------------+-----------+---------------+--------------+------------------+-----------------+--------------------+---------------+----------------|
# >> | id  | battle_id | user_id | op_user_id | grade_id | judge_key | location_key | position | grade_diff | created_at                | updated_at                | think_all_avg | think_end_avg | two_serial_max | think_last | think_max | obt_think_avg | obt_auto_max | defense_tag_list | attack_tag_list | technique_tag_list | note_tag_list | other_tag_list |
# >> |-----+-----------+---------+------------+----------+-----------+--------------+----------+------------+---------------------------+---------------------------+---------------+---------------+----------------+------------+-----------+---------------+--------------+------------------+-----------------+--------------------+---------------+----------------|
# >> | 373 |       187 |      47 |         48 |       40 | win       | black        |        0 |          0 | 2022-05-22 17:18:14 +0900 | 2022-05-22 17:18:14 +0900 |             2 |             2 |              1 |          2 |         5 |               |              |                  |                 |                    |               |                |
# >> | 374 |       187 |      48 |         47 |       40 | lose      | white        |        1 |          0 | 2022-05-22 17:18:14 +0900 | 2022-05-22 17:18:14 +0900 |             5 |             5 |                |          7 |         7 |               |              |                  |                 |                    |               |                |
# >> | 375 |       188 |      47 |         48 |       12 | win       | black        |        0 |          0 | 2022-05-22 17:18:14 +0900 | 2022-05-22 17:18:14 +0900 |             2 |             2 |              1 |          2 |         5 |               |              |                  |                 |                    |               |                |
# >> | 376 |       188 |      48 |         47 |       12 | lose      | white        |        1 |          0 | 2022-05-22 17:18:14 +0900 | 2022-05-22 17:18:14 +0900 |             5 |             5 |                |          7 |         7 |               |              |                  |                 |                    |               |                |
# >> | 377 |       189 |      47 |         48 |       11 | win       | black        |        0 |          0 | 2022-05-22 17:18:14 +0900 | 2022-05-22 17:18:14 +0900 |             2 |             2 |              1 |          2 |         5 |               |              |                  |                 |                    |               |                |
# >> | 378 |       189 |      48 |         47 |       11 | lose      | white        |        1 |          0 | 2022-05-22 17:18:14 +0900 | 2022-05-22 17:18:14 +0900 |             5 |             5 |                |          7 |         7 |               |              |                  |                 |                    |               |                |
# >> | 379 |       190 |      47 |         48 |       11 | win       | black        |        0 |          0 | 2022-05-22 17:18:14 +0900 | 2022-05-22 17:18:14 +0900 |             2 |             2 |              1 |          2 |         5 |               |              |                  |                 |                    |               |                |
# >> | 380 |       190 |      48 |         47 |       11 | lose      | white        |        1 |          0 | 2022-05-22 17:18:14 +0900 | 2022-05-22 17:18:14 +0900 |             5 |             5 |                |          7 |         7 |               |              |                  |                 |                    |               |                |
# >> |-----+-----------+---------+------------+----------+-----------+--------------+----------+------------+---------------------------+---------------------------+---------------+---------------+----------------+------------+-----------+---------------+--------------+------------------+-----------------+--------------------+---------------+----------------|
# >> Scoped order is ignored, it's forced to be batch order.
# >>    (0.4ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` ORDER BY `swars_memberships`.`id` DESC LIMIT 2
# >>   Swars::Membership Load (0.4ms)  SELECT `swars_memberships`.* FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (380, 379) /* loading for inspect */ ORDER BY `swars_memberships`.`id` DESC LIMIT 11
# >> #<ActiveRecord::Relation [#<Swars::Membership id: 380, battle_id: 190, user_id: 48, op_user_id: 47, grade_id: 11, judge_key: "lose", location_key: "white", position: 1, grade_diff: 0, created_at: "2022-05-22 17:18:14.000000000 +0900", updated_at: "2022-05-22 17:18:14.000000000 +0900", think_all_avg: 5, think_end_avg: 5, two_serial_max: nil, think_last: 7, think_max: 7, obt_think_avg: nil, obt_auto_max: nil, defense_tag_list: nil, attack_tag_list: nil, technique_tag_list: nil, note_tag_list: nil, other_tag_list: nil>, #<Swars::Membership id: 379, battle_id: 190, user_id: 47, op_user_id: 48, grade_id: 11, judge_key: "win", location_key: "black", position: 0, grade_diff: 0, created_at: "2022-05-22 17:18:14.000000000 +0900", updated_at: "2022-05-22 17:18:14.000000000 +0900", think_all_avg: 2, think_end_avg: 2, two_serial_max: 1, think_last: 2, think_max: 5, obt_think_avg: nil, obt_auto_max: nil, defense_tag_list: nil, attack_tag_list: nil, technique_tag_list: nil, note_tag_list: nil, other_tag_list: nil>]>
# >>    (0.4ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` WHERE `swars_memberships`.`id` < 379 ORDER BY `swars_memberships`.`id` DESC LIMIT 2
# >>   Swars::Membership Load (0.3ms)  SELECT `swars_memberships`.* FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (378, 377) /* loading for inspect */ ORDER BY `swars_memberships`.`id` DESC LIMIT 11
# >> #<ActiveRecord::Relation [#<Swars::Membership id: 378, battle_id: 189, user_id: 48, op_user_id: 47, grade_id: 11, judge_key: "lose", location_key: "white", position: 1, grade_diff: 0, created_at: "2022-05-22 17:18:14.000000000 +0900", updated_at: "2022-05-22 17:18:14.000000000 +0900", think_all_avg: 5, think_end_avg: 5, two_serial_max: nil, think_last: 7, think_max: 7, obt_think_avg: nil, obt_auto_max: nil, defense_tag_list: nil, attack_tag_list: nil, technique_tag_list: nil, note_tag_list: nil, other_tag_list: nil>, #<Swars::Membership id: 377, battle_id: 189, user_id: 47, op_user_id: 48, grade_id: 11, judge_key: "win", location_key: "black", position: 0, grade_diff: 0, created_at: "2022-05-22 17:18:14.000000000 +0900", updated_at: "2022-05-22 17:18:14.000000000 +0900", think_all_avg: 2, think_end_avg: 2, two_serial_max: 1, think_last: 2, think_max: 5, obt_think_avg: nil, obt_auto_max: nil, defense_tag_list: nil, attack_tag_list: nil, technique_tag_list: nil, note_tag_list: nil, other_tag_list: nil>]>
# >>    (0.3ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` WHERE `swars_memberships`.`id` < 377 ORDER BY `swars_memberships`.`id` DESC LIMIT 2
# >>   Swars::Membership Load (0.3ms)  SELECT `swars_memberships`.* FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (376, 375) /* loading for inspect */ ORDER BY `swars_memberships`.`id` DESC LIMIT 11
# >> #<ActiveRecord::Relation [#<Swars::Membership id: 376, battle_id: 188, user_id: 48, op_user_id: 47, grade_id: 12, judge_key: "lose", location_key: "white", position: 1, grade_diff: 0, created_at: "2022-05-22 17:18:14.000000000 +0900", updated_at: "2022-05-22 17:18:14.000000000 +0900", think_all_avg: 5, think_end_avg: 5, two_serial_max: nil, think_last: 7, think_max: 7, obt_think_avg: nil, obt_auto_max: nil, defense_tag_list: nil, attack_tag_list: nil, technique_tag_list: nil, note_tag_list: nil, other_tag_list: nil>, #<Swars::Membership id: 375, battle_id: 188, user_id: 47, op_user_id: 48, grade_id: 12, judge_key: "win", location_key: "black", position: 0, grade_diff: 0, created_at: "2022-05-22 17:18:14.000000000 +0900", updated_at: "2022-05-22 17:18:14.000000000 +0900", think_all_avg: 2, think_end_avg: 2, two_serial_max: 1, think_last: 2, think_max: 5, obt_think_avg: nil, obt_auto_max: nil, defense_tag_list: nil, attack_tag_list: nil, technique_tag_list: nil, note_tag_list: nil, other_tag_list: nil>]>
# >>    (0.4ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` WHERE `swars_memberships`.`id` < 375 ORDER BY `swars_memberships`.`id` DESC LIMIT 2
# >>   Swars::Membership Load (0.4ms)  SELECT `swars_memberships`.* FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (374, 373) /* loading for inspect */ ORDER BY `swars_memberships`.`id` DESC LIMIT 11
# >> #<ActiveRecord::Relation [#<Swars::Membership id: 374, battle_id: 187, user_id: 48, op_user_id: 47, grade_id: 40, judge_key: "lose", location_key: "white", position: 1, grade_diff: 0, created_at: "2022-05-22 17:18:14.000000000 +0900", updated_at: "2022-05-22 17:18:14.000000000 +0900", think_all_avg: 5, think_end_avg: 5, two_serial_max: nil, think_last: 7, think_max: 7, obt_think_avg: nil, obt_auto_max: nil, defense_tag_list: nil, attack_tag_list: nil, technique_tag_list: nil, note_tag_list: nil, other_tag_list: nil>, #<Swars::Membership id: 373, battle_id: 187, user_id: 47, op_user_id: 48, grade_id: 40, judge_key: "win", location_key: "black", position: 0, grade_diff: 0, created_at: "2022-05-22 17:18:14.000000000 +0900", updated_at: "2022-05-22 17:18:14.000000000 +0900", think_all_avg: 2, think_end_avg: 2, two_serial_max: 1, think_last: 2, think_max: 5, obt_think_avg: nil, obt_auto_max: nil, defense_tag_list: nil, attack_tag_list: nil, technique_tag_list: nil, note_tag_list: nil, other_tag_list: nil>]>
# >>    (0.4ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` WHERE `swars_memberships`.`id` < 373 ORDER BY `swars_memberships`.`id` DESC LIMIT 2
