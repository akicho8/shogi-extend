#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

module Fanta
  user1 = User.create!

  100.times do
    user2 = User.create!
    battle = Battle.create!
    if rand(2).zero?
      battle.update!(begin_at: Time.current)
    end
    battle.users << user1
    battle.users << user2
  end

  p Battle.count
end
