require "#{__dir__}/setup"
ShareBoard.setup(force: true)
ShareBoard::Room.mock
s { ShareBoard::Dashboard.new(room_key: :dev_room1).call }
pp ShareBoard::Dashboard.new(room_key: :dev_room1).call
# >>   ShareBoard::Room Load (0.3ms)  SELECT `share_board_rooms`.* FROM `share_board_rooms` WHERE `share_board_rooms`.`key` = 'dev_room1' LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/share_board/dashboard.rb:13:in 'ShareBoard::Dashboard#call'
# >>   ShareBoard::Roomship Load (0.2ms)  SELECT `share_board_roomships`.* FROM `share_board_roomships` WHERE `share_board_roomships`.`room_id` = 1 ORDER BY `share_board_roomships`.`rank` ASC /*application='ShogiWeb'*/
# >>   ↳ app/models/share_board/dashboard.rb:13:in 'ShareBoard::Dashboard#call'
# >>   ShareBoard::User Load (0.2ms)  SELECT `share_board_users`.* FROM `share_board_users` WHERE `share_board_users`.`id` IN (1, 3, 2) /*application='ShogiWeb'*/
# >>   ↳ app/models/share_board/dashboard.rb:13:in 'ShareBoard::Dashboard#call'
# >>   ShareBoard::Battle Load (0.2ms)  SELECT `share_board_battles`.* FROM `share_board_battles` WHERE `share_board_battles`.`room_id` = 1 ORDER BY `share_board_battles`.`created_at` DESC LIMIT 50 /*application='ShogiWeb'*/
# >>   ↳ app/models/share_board/room.rb:105:in 'ShareBoard::Room#latest_battles'
# >>   Location Load (0.4ms)  SELECT `locations`.* FROM `locations` WHERE `locations`.`key` = 'black' ORDER BY `locations`.`position` ASC LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/application_memory_record.rb:36:in 'ApplicationMemoryRecord#db_record!'
# >>   Location Load (0.4ms)  SELECT `locations`.* FROM `locations` WHERE `locations`.`key` = 'white' ORDER BY `locations`.`position` ASC LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/application_memory_record.rb:36:in 'ApplicationMemoryRecord#db_record!'
# >>   Location Load (0.2ms)  SELECT `locations`.* FROM `locations` WHERE `locations`.`id` = 1 ORDER BY `locations`.`position` ASC /*application='ShogiWeb'*/
# >>   ↳ app/models/share_board/room.rb:105:in 'ShareBoard::Room#latest_battles'
# >>   ShareBoard::Membership Load (0.5ms)  SELECT `share_board_memberships`.* FROM `share_board_memberships` WHERE `share_board_memberships`.`location_id` = 1 AND `share_board_memberships`.`battle_id` = 1 ORDER BY `share_board_memberships`.`position` ASC /*application='ShogiWeb'*/
# >>   ↳ app/models/share_board/room.rb:105:in 'ShareBoard::Room#latest_battles'
# >>   ShareBoard::Membership Load (0.6ms)  SELECT `share_board_memberships`.* FROM `share_board_memberships` WHERE `share_board_memberships`.`location_id` = 2 AND `share_board_memberships`.`battle_id` = 1 ORDER BY `share_board_memberships`.`position` ASC /*application='ShogiWeb'*/
# >>   ↳ app/models/share_board/room.rb:105:in 'ShareBoard::Room#latest_battles'
# >>   ShareBoard::User Load (1.4ms)  SELECT `share_board_users`.* FROM `share_board_users` WHERE `share_board_users`.`id` IN (1, 3, 2) /*application='ShogiWeb'*/
# >>   ↳ app/models/share_board/room.rb:105:in 'ShareBoard::Room#latest_battles'
# >>   Location Load (0.2ms)  SELECT `locations`.* FROM `locations` WHERE `locations`.`key` = 'black' ORDER BY `locations`.`position` ASC LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/application_memory_record.rb:36:in 'ApplicationMemoryRecord#db_record!'
# >>   Location Load (0.2ms)  SELECT `locations`.* FROM `locations` WHERE `locations`.`key` = 'white' ORDER BY `locations`.`position` ASC LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/application_memory_record.rb:36:in 'ApplicationMemoryRecord#db_record!'
# >> {"key" => "dev_room1",
# >>  "latest_battles_max" => 50,
# >>  "latest_battles" =>
# >>   [{"sfen" =>
# >>      "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d 8h2b+ 3a2b",
# >>     "position" => 0,
# >>     "created_at" => "2025-10-22T18:12:22.000+09:00",
# >>     "win_location" => {"key" => "black"},
# >>     "black" =>
# >>      [{"user" => {"name" => "alice"}}, {"user" => {"name" => "carol"}}],
# >>     "white" => [{"user" => {"name" => "bob"}}]}],
# >>  "roomships" =>
# >>   [{"win_count" => 1,
# >>     "lose_count" => 0,
# >>     "battles_count" => 1,
# >>     "win_rate" => 1.0,
# >>     "score" => 1,
# >>     "rank" => 1,
# >>     "user" => {"name" => "alice"}},
# >>    {"win_count" => 1,
# >>     "lose_count" => 0,
# >>     "battles_count" => 1,
# >>     "win_rate" => 1.0,
# >>     "score" => 1,
# >>     "rank" => 1,
# >>     "user" => {"name" => "carol"}},
# >>    {"win_count" => 0,
# >>     "lose_count" => 1,
# >>     "battles_count" => 1,
# >>     "win_rate" => 0.0,
# >>     "score" => 0,
# >>     "rank" => 3,
# >>     "user" => {"name" => "bob"}}]}
