#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

# list = ActiveRecord::Base.connection.tables.sort.flat_map do |table|
#   ActiveRecord::Base.connection.indexes(table).collect do |obj|
#     [:table, :name, :unique, :columns, :lengths, :orders, :opclasses, :where, :type, :using, :comment].inject({}) { |a, e| a.merge(e => obj.send(e)) }
#   end
# end
# tp list

Swars::User.destroy_all
Swars::Battle.destroy_all
Swars.setup

user1 = Swars::User.create!
user2 = Swars::User.create!

# ActiveSupport::LogSubscriber.colorize_logging = false
# logger = ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
# ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)

battle = Swars::Battle.create! do |e|
  e.csa_seq = [["-7162GI", 599],  ["+2726FU", 597]]
  e.memberships.build(user: user1, judge_key: :win,  location_key: :black)
  e.memberships.build(user: user2, judge_key: :lose, location_key: :white)
end

# ActiveRecord::Base.logger = logger

tp battle.memberships
# >> |----+-----------+---------+----------+-----------+--------------+----------+---------------------------+---------------------------+------------+-----------+------------+------------+---------------+---------------+----------------+------------------+-----------------+--------------------+---------------+----------------|
# >> | id | battle_id | user_id | grade_id | judge_key | location_key | position | created_at                | updated_at                | grade_diff | think_max | op_user_id | think_last | think_all_avg | think_end_avg | two_serial_max | defense_tag_list | attack_tag_list | technique_tag_list | note_tag_list | other_tag_list |
# >> |----+-----------+---------+----------+-----------+--------------+----------+---------------------------+---------------------------+------------+-----------+------------+------------+---------------+---------------+----------------+------------------+-----------------+--------------------+---------------+----------------|
# >> | 83 |        42 |      61 |       40 | win       | black        |        0 | 2020-04-01 12:01:25 +0900 | 2020-04-01 12:01:25 +0900 |          0 |         1 |         62 |          1 |             1 |             1 |                |                  |                 |                    | 居飛車 居玉   |                |
# >> | 84 |        42 |      62 |       40 | lose      | white        |        1 | 2020-04-01 12:01:25 +0900 | 2020-04-01 12:01:25 +0900 |          0 |         3 |         61 |          3 |             3 |             3 |                |                  |                 |                    | 居飛車 居玉   |                |
# >> |----+-----------+---------+----------+-----------+--------------+----------+---------------------------+---------------------------+------------+-----------+------------+------------+---------------+---------------+----------------+------------------+-----------------+--------------------+---------------+----------------|
