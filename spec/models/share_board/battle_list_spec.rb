require "rails_helper"

RSpec.describe ShareBoard::BattleList do
  it "call" do
    room_key = "dev_room1"
    room = ShareBoard::Room.create!(key: room_key)
    room.redis_clear
    room.battles.create!(win_location_key: "black") do |e|
      e.memberships.build([
          { user_name: "alice", location_key: "black", judge_key: "win",  },
          { user_name: "bob",   location_key: "white", judge_key: "lose", },
        ])
    end
    json = ShareBoard::BattleList.new(room_key: room_key, page: 1, per: 10).call
    tp json if $0 == __FILE__
    assert { json[:key] == "dev_room1" }
    assert { json[:total] == 1 }
    assert { json[:page] == 1 }
    assert { json[:per] == 10 }
    assert { json[:battles].present? }
  end
end
# >> Run options: exclude {ai_active: true, login_spec: true, slow_spec: true}
# >> 
# >> ShareBoard::BattleList
# >> |---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |     key | dev_room1                                                                                                                                                                                                                                                           |
# >> |   total | 1                                                                                                                                                                                                                                                                   |
# >> |    page | 1                                                                                                                                                                                                                                                                   |
# >> |     per | 10                                                                                                                                                                                                                                                                  |
# >> | battles | [{"id" => 1, "sfen" => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d 8h2b+ 3a2b", "turn" => 4, "position" => 0, "created_at" => "2000-01-01T00:00:00.000+09:00", "win_location" => {"key" => "black"}, "black" ... |
# >> |---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >>   call
# >> 
# >> Top 1 slowest examples (0.61926 seconds, 19.6% of total time):
# >>   ShareBoard::BattleList call
# >>     0.61926 seconds -:4
# >> 
# >> Finished in 3.16 seconds (files took 2.35 seconds to load)
# >> 1 example, 0 failures
# >> 
