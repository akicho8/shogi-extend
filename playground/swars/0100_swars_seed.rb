#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)
ForeignKey.disabled

Swars::User.destroy_all
Swars::Battle.destroy_all

user1 = Swars::User.create!
user2 = Swars::User.create!
user3 = Swars::User.create!

2.times do
  Swars::Battle.create! do |e|
    e.memberships.build(user: user1)
    e.memberships.build(user: user2)
  end
end
2.times do
  Swars::Battle.create! do |e|
    e.memberships.build(user: user2)
    e.memberships.build(user: user3)
  end
end
2.times do
  Swars::Battle.create! do |e|
    e.memberships.build(user: user1)
    e.memberships.build(user: user3)
  end
end
