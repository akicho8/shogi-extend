#!/usr/bin/env ruby
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

create.call("2級", 1)
create.call("1級", 2)
# create.call("初段", 3)
# create.call("二段", 2)
# create.call("三段", 1)

ActiveSupport::LogSubscriber.colorize_logging = false
ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)

s = Swars::Membership.all
# s = s.joins(:battle).merge(Swars::Battle.rule_eq("10分"))
# s = s.tagged_with("新嬉野流")
s = s.where(grade: Swars::Grade.all.unscope(:order))
ids = s.order(id: :desc).pluck(:id)
counts = Swars::Membership.where(id: ids).group(:grade).count
tp counts

# tp Swars::Membership.tagged_with("")
# tp Swars::Membership.tag_counts_on(:attack_tags)

# tp Swars::User
# tp Swars::Membership

# >>    (2.1ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` WHERE `swars_memberships`.`grade_id` IN (SELECT `swars_grades`.`id` FROM `swars_grades`) ORDER BY `swars_memberships`.`id` DESC
# >>    (0.5ms)  SELECT COUNT(*) AS count_all, `swars_memberships`.`grade_id` AS swars_memberships_grade_id FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (1454, 1453, 1452, 1451, 1450, 1449) GROUP BY `swars_memberships`.`grade_id`
# >>   Swars::Grade Load (0.4ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` IN (11, 12) ORDER BY `swars_grades`.`priority` ASC
# >> |------------------------------------+---|
# >> | #<Swars::Grade:0x00007ff618b0a930> | 4 |
# >> | #<Swars::Grade:0x00007ff618b0a840> | 2 |
# >> |------------------------------------+---|
