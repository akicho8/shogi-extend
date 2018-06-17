#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

user1 = Fanta::User.create!(online_at: Time.current)

100.times do
  user2 = Fanta::User.create!(online_at: Time.current)
  battle = Fanta::Battle.create!
  if (rand(2).zero?)
    battle.update!(begin_at: Time.current)
  end
  battle.users << user1
  battle.users << user2
end

p Fanta::Battle.count
