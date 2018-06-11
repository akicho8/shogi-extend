#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

user1 = User.create!(online_at: Time.current)

100.times do
  user2 = User.create!(online_at: Time.current)
  battle_room = BattleRoom.create!
  if (rand(2).zero?)
    battle_room.update!(begin_at: Time.current)
  end
  battle_room.users << user1
  battle_room.users << user2
end

p BattleRoom.count
