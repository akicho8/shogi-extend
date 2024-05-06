#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)
Swars::User.destroy_all
Swars::Battle.destroy_all

user1 = Swars::User.create!
user2 = Swars::User.create!
battle = Swars::Battle.create!(kifu_generator: [3, 1, 2, 2, 2]) do |e|
  e.memberships.build(user: user1)
  e.memberships.build(user: user2)
end
