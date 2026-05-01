require "rails_helper"

RSpec.describe ShareBoard::BattleRanking do
  it "call" do
    room_key = "dev_room1"
    room = ShareBoard::Room.create!(key: room_key)
    room.battles.create!(win_location_key: "black") do |e|
      e.memberships.build([
          { user_name: "alice", location_key: "black", judge_key: "win",  },
          { user_name: "bob",   location_key: "white", judge_key: "lose", },
        ])
    end
    json = ShareBoard::BattleRanking.new(room_key: room_key).call
    tp json if $0 == __FILE__
    assert { json["key"] == "dev_room1" }
    assert { json["roomships"].present? }
  end
end
