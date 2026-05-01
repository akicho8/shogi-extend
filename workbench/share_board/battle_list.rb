require "#{__dir__}/setup"
ShareBoard.setup(force: true)

room_key = "dev_room"
room = ShareBoard::Room.create!(key: "dev_room", name: "(room.name)")
25.times do |i|
  records = [
    { user_name: "alice", location_key: "black", judge_key: "win",  },
    { user_name: "bob",   location_key: "white", judge_key: "lose", },
    { user_name: "carol", location_key: "black", judge_key: "win",  },
  ]
  room.battles.create!(win_location_key: "black", created_at: "2000-01-01".to_date + i) do |e|
    e.memberships.build(records)
  end
end

# s { ShareBoard::BattleList.new(room_key: room_key).call }
# pp ShareBoard::BattleList.new(room_key: room_key).call
ShareBoard::Battle.count    # => 2

# >>   ShareBoard::Room Load (0.3ms)  SELECT `share_board_rooms`.* FROM `share_board_rooms` WHERE `share_board_rooms`.`key` = 'dev_room' LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/share_board/battle_list.rb:11:in 'ShareBoard::BattleList#call'
# >>   ShareBoard::Roomship Load (0.3ms)  SELECT `share_board_roomships`.* FROM `share_board_roomships` WHERE `share_board_roomships`.`room_id` = 1 ORDER BY `share_board_roomships`.`rank` ASC /*application='ShogiWeb'*/
# >>   ↳ app/models/share_board/battle_list.rb:11:in 'ShareBoard::BattleList#call'
# >>   ShareBoard::User Load (0.3ms)  SELECT `share_board_users`.* FROM `share_board_users` WHERE `share_board_users`.`id` IN (1, 3, 2) /*application='ShogiWeb'*/
# >>   ↳ app/models/share_board/battle_list.rb:11:in 'ShareBoard::BattleList#call'
# >>   ShareBoard::Battle Load (0.3ms)  SELECT `share_board_battles`.* FROM `share_board_battles` WHERE `share_board_battles`.`room_id` = 1 ORDER BY `share_board_battles`.`created_at` DESC LIMIT 50 /*application='ShogiWeb'*/
# >>   ↳ app/models/share_board/room.rb:108:in 'ShareBoard::Room#latest_battles'
# >>   Location Load (0.2ms)  SELECT `locations`.* FROM `locations` WHERE `locations`.`key` = 'black' ORDER BY `locations`.`position` ASC LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/application_memory_record.rb:36:in 'ApplicationMemoryRecord#db_record!'
# >>   Location Load (0.2ms)  SELECT `locations`.* FROM `locations` WHERE `locations`.`key` = 'white' ORDER BY `locations`.`position` ASC LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/application_memory_record.rb:36:in 'ApplicationMemoryRecord#db_record!'
# >>   Location Load (0.2ms)  SELECT `locations`.* FROM `locations` WHERE `locations`.`id` = 1 ORDER BY `locations`.`position` ASC /*application='ShogiWeb'*/
# >>   ↳ app/models/share_board/room.rb:108:in 'ShareBoard::Room#latest_battles'
# >>   ShareBoard::Membership Load (0.4ms)  SELECT `share_board_memberships`.* FROM `share_board_memberships` WHERE `share_board_memberships`.`location_id` = 1 AND `share_board_memberships`.`battle_id` IN (1, 2) ORDER BY `share_board_memberships`.`position` ASC /*application='ShogiWeb'*/
# >>   ↳ app/models/share_board/room.rb:108:in 'ShareBoard::Room#latest_battles'
# >>   ShareBoard::Membership Load (0.3ms)  SELECT `share_board_memberships`.* FROM `share_board_memberships` WHERE `share_board_memberships`.`location_id` = 2 AND `share_board_memberships`.`battle_id` IN (1, 2) ORDER BY `share_board_memberships`.`position` ASC /*application='ShogiWeb'*/
# >>   ↳ app/models/share_board/room.rb:108:in 'ShareBoard::Room#latest_battles'
# >>   ShareBoard::User Load (0.3ms)  SELECT `share_board_users`.* FROM `share_board_users` WHERE `share_board_users`.`id` IN (1, 3, 2) /*application='ShogiWeb'*/
# >>   ↳ app/models/share_board/room.rb:108:in 'ShareBoard::Room#latest_battles'
# >>   Location Load (0.2ms)  SELECT `locations`.* FROM `locations` WHERE `locations`.`key` = 'black' ORDER BY `locations`.`position` ASC LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/application_memory_record.rb:36:in 'ApplicationMemoryRecord#db_record!'
# >>   Location Load (0.2ms)  SELECT `locations`.* FROM `locations` WHERE `locations`.`key` = 'white' ORDER BY `locations`.`position` ASC LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/application_memory_record.rb:36:in 'ApplicationMemoryRecord#db_record!'
# >>   Location Load (0.3ms)  SELECT `locations`.* FROM `locations` WHERE `locations`.`key` = 'black' ORDER BY `locations`.`position` ASC LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/application_memory_record.rb:36:in 'ApplicationMemoryRecord#db_record!'
# >>   Location Load (0.3ms)  SELECT `locations`.* FROM `locations` WHERE `locations`.`key` = 'white' ORDER BY `locations`.`position` ASC LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/application_memory_record.rb:36:in 'ApplicationMemoryRecord#db_record!'
# >> {"key" => "dev_room",
# >>  "battles_count" => 2,
# >>  "latest_battles_max" => 50,
# >>  "latest_battles" =>
# >>   [{"sfen" =>
# >>      "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d 8h2b+ 3a2b",
# >>     "turn" => 4,
# >>     "position" => 0,
# >>     "created_at" => "2026-04-26T09:13:08.000+09:00",
# >>     "win_location" => {"key" => "black"},
# >>     "black" =>
# >>      [{"user" => {"name" => "alice"}}, {"user" => {"name" => "carol"}}],
# >>     "white" => [{"user" => {"name" => "bob"}}]},
# >>    {"sfen" =>
# >>      "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d 8h2b+ 3a2b",
# >>     "turn" => 4,
# >>     "position" => 1,
# >>     "created_at" => "2026-04-26T09:13:08.000+09:00",
# >>     "win_location" => {"key" => "black"},
# >>     "black" =>
# >>      [{"user" => {"name" => "alice"}}, {"user" => {"name" => "carol"}}],
# >>     "white" => [{"user" => {"name" => "bob"}}]}]}
