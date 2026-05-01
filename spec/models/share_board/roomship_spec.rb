require "rails_helper"

RSpec.describe ShareBoard::Roomship, type: :model do
  it "ランキング" do
    room = ShareBoard::Room.create!
    room.battles.create! do |e|
      e.memberships.build([
          { user_name: "alice", location_key: "black", judge_key: "win",  },
          { user_name: "bob",   location_key: "white", judge_key: "lose", },
          { user_name: "carol", location_key: "black", judge_key: "win",  },
        ])
    end
    assert { room.reload.roomships.collect(&:rank) === [1, 1, 3] }
    tp room.roomships if $0 == __FILE__
  end

  it "引き分け" do
    room = ShareBoard::Room.create!
    room.battles.create! do |e|
      e.memberships.build([
          { user_name: "alice", location_key: "black", judge_key: "draw", },
          { user_name: "bob",   location_key: "white", judge_key: "draw", },
          { user_name: "carol", location_key: "black", judge_key: "draw", },
        ])
    end
    assert { room.reload.roomships.collect(&:rank) === [1, 1, 1] }
    tp room.roomships if $0 == __FILE__
  end
end
