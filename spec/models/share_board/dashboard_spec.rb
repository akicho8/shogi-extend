require "rails_helper"

RSpec.describe ShareBoard::Dashboard do
  it "call" do
    room = ShareBoard::Room.create!
    room.redis_clear
    room.battles.create! do |e|
      e.memberships.build([
          { user_name: "alice", location_key: "black", judge_key: "win",  },
          { user_name: "bob",   location_key: "white", judge_key: "lose", },
        ])
    end
    json = ShareBoard::Dashboard.new(room_key: "test_room").call
    assert { json }
    tp json if $0 == __FILE__
  end
end
# >> ShareBoard::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> ShareBoard::Dashboard
# >> |-----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |       key | test_room                                                                                                                                                                                                                                                            |
# >> | roomships | [{"win_count"=>1, "lose_count"=>0, "battles_count"=>1, "win_rate"=>1.0, "score"=>1, "rank"=>1, "user"=>{"name"=>"alice"}}, {"win_count"=>0, "lose_count"=>1, "battles_count"=>1, "win_rate"=>0.0, "score"=>0, "rank"=>2, "user"=>{"name"=>"bob"}}]                  |
# >> |   battles | [{"sfen"=>"position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d 8h2b+ 3a2b", "position"=>0, "created_at"=>"2023-12-17T18:12:05.000+09:00", "win_location"=>{"key"=>"black"}, "black"=>[{"id"=>43, "battle_id"=>15, "use... |
# >> |-----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >>   call
# >>
# >> ShareBoard::Top 1 slowest examples (0.42624 seconds, 17.1% of total time):
# >>   ShareBoard::Dashboard call
# >>     0.42624 seconds -:5
# >>
# >> ShareBoard::Finished in 2.5 seconds (files took 1.56 seconds to load)
# >> 1 example, 0 failures
# >>
