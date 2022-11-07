#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

Swars::User.destroy_all
Swars::Battle.destroy_all

# user1 = Swars::User.create!
# user2 = Swars::User.create!
#
# battle = Swars::Battle.new(tactic_key: "嬉野流")
# battle.memberships.build(user: user1)
# battle.memberships.build(user: user2)
# battle.save!
#
# battle = Swars::Battle.new(tactic_key: "棒銀")
# battle.memberships.build(user: user1)
# battle.memberships.build(user: user2)
# battle.save!

user1 = Swars::User.create!
user2 = Swars::User.create!
10.times do |i|
  battle = Swars::Battle.new
  battle.memberships.build(user: user1, judge_key: i.even? ? "win" : "lose")
  battle.memberships.build(user: user2, judge_key: i.even? ? "lose" : "win")
  battle.battled_at = (6 * i).hours.from_now
  battle.save!
end

tp Swars::User.first.user_info.to_hash
