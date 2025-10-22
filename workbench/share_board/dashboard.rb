require "#{__dir__}/setup"
ShareBoard.setup(force: true)
ShareBoard::Room.mock
json = ShareBoard::Dashboard.new(room_key: :dev_room1).call
tp json
# >> |----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                  key | dev_room1                                                                                                                                                                                                                                                           |
# >> | latest_battles_max | 50                                                                                                                                                                                                                                                                  |
# >> |       latest_battles | [{"sfen" => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d 8h2b+ 3a2b", "position" => 0, "created_at" => "2025-10-22T16:21:01.000+09:00", "win_location" => {"key" => "black"}, "black" => [{"user" => {"name" =... |
# >> |            roomships | [{"win_count" => 1, "lose_count" => 0, "battles_count" => 1, "win_rate" => 1.0, "score" => 1, "rank" => 1, "user" => {"name" => "alice"}}, {"win_count" => 1, "lose_count" => 0, "battles_count" => 1, "win_rate" => 1.0, "score" => 1, "rank" => 1, "user" => {... |
# >> |----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
