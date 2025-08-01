# -*- coding: utf-8 -*-

require "rails_helper"

RSpec.describe ShareBoard::Battle, type: :model do
  it "works" do
    room = ShareBoard::Room.create!
    battle = room.battles.create! do |e|
      e.memberships.build([
          { user_name: "alice", location_key: "black", judge_key: "win",  },
          { user_name: "bob",   location_key: "white", judge_key: "lose", },
          { user_name: "carol", location_key: "black", judge_key: "win",  },
        ])
    end
    assert { battle.black.collect { |e| e.user.name } == ["alice", "carol"] }
    assert { battle.white.collect { |e| e.user.name } == ["bob"] }
  end
end
