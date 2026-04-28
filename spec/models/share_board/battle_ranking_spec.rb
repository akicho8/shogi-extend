require "rails_helper"

RSpec.describe ShareBoard::BattleRanking do
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
    json = ShareBoard::BattleRanking.new(room_key: room_key).call
    tp json if $0 == __FILE__
    assert { json["key"] == "dev_room1" }
    assert { json["roomships"].present? }
  end
end
# >> Run options: exclude {ai_active: true, login_spec: true, slow_spec: true}
# >> 
# >> ShareBoard::BattleRanking
# >> |-----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |       key | dev_room1                                                                                                                                                                                                                                                           |
# >> | roomships | [{"win_count" => 1, "lose_count" => 0, "battles_count" => 1, "win_rate" => 1.0, "score" => 1, "rank" => 1, "user" => {"name" => "alice"}}, {"win_count" => 0, "lose_count" => 1, "battles_count" => 1, "win_rate" => 0.0, "score" => 0, "rank" => 2, "user" => {... |
# >> |-----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >>   call (FAILED - 1)
# >> 
# >> Failures:
# >> 
# >>   1) ShareBoard::BattleRanking call
# >>      Failure/Error: Unable to find - to read failed line
# >>      Minitest::Assertion:
# >>      # -:16:in 'block (2 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:27:in 'block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:27:in 'block (2 levels) in <main>'
# >> 
# >> Top 1 slowest examples (0.45077 seconds, 15.6% of total time):
# >>   ShareBoard::BattleRanking call
# >>     0.45077 seconds -:4
# >> 
# >> Finished in 2.9 seconds (files took 2.16 seconds to load)
# >> 1 example, 1 failure
# >> 
# >> Failed examples:
# >> 
# >> rspec -:4 # ShareBoard::BattleRanking call
# >> 
