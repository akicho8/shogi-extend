require "#{__dir__}/setup"
ShareBoard.setup(force: true)

params = {
  :room_key         => "dns",
  :title            => "共有将棋盤",
  :sfen             => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d 2g2f 4c4d 3i4h 1c1d 1g1f 9c9d 9g9f 8b4b 2f2e 2b3c 5i6h 5a6b 6h7h 4a5b 4i5h 3a3b 5g5f 6b7b 4h5g 7b8b 3g3f 7a7b 6i6h 4d4e 2i3g 3c8h+ 7i8h 3b3c 5f5e 3d3e 3f3e 1d1e 2e2d 3c2d B*3d 4e4f 4g4f 4b2b 5e5d 2d3e 5d5c+ 5b5c 3g4e 5c5b P*5d P*5f 5g4h 3e4d 5d5c+ 4d5c 4e5c+ 5b5c 3d2c+ 2b2c 2h2c+ P*4c 2c2a B*1b 2a1b 1a1b R*2a 5f5g+ 4h5g P*5a 9f9e R*3i B*1g 3i3b+ 1g5c+ 3b2a N*9c B*4d 9c8a+ 7b8a 5c4c 4d8h+ 7h8h 2a2i 4c6a S*7i 8h9g N*8e 9g8f N*7d 8f7e 2i2e N*6e 7i6h B*7a",
  :turn             => 91,
  :win_location_key => "black",
  :memberships => [
    { :user_name => "電子れいず",   :location_key => "black", :judge_key => "win",  },
    { :user_name => "都賀町えいだ", :location_key => "white", :judge_key => "lose", },
  ],
}

ActiveSupport::LogSubscriber.colorize_logging = false
ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)

battle_create = ShareBoard::BattleCreate.new(params)
battle_create.call

tp battle_create.battle.room
tp battle_create.battle
tp battle_create.battle.memberships
tp battle_create.battle.room.users

# >>   ShareBoard::User Load (1.7ms)  SELECT `share_board_users`.* FROM `share_board_users` WHERE `share_board_users`.`name` = '電子れいず' LIMIT 1
# >>   ↳ app/models/share_board/user.rb:48:in `fetch'
# >>   TRANSACTION (0.2ms)  BEGIN
# >>   ↳ app/models/share_board/user.rb:48:in `fetch'
# >>   ShareBoard::User Exists? (0.4ms)  SELECT 1 AS one FROM `share_board_users` WHERE `share_board_users`.`name` = '電子れいず' LIMIT 1
# >>   ↳ app/models/share_board/user.rb:48:in `fetch'
# >>   ShareBoard::User Create (0.6ms)  INSERT INTO `share_board_users` (`name`, `memberships_count`, `created_at`, `updated_at`, `chat_messages_count`) VALUES ('電子れいず', 0, '2024-03-08 05:55:03', '2024-03-08 05:55:03', 0)
# >>   ↳ app/models/share_board/user.rb:48:in `fetch'
# >>   TRANSACTION (0.9ms)  COMMIT
# >>   ↳ app/models/share_board/user.rb:48:in `fetch'
# >>   ShareBoard::User Load (0.4ms)  SELECT `share_board_users`.* FROM `share_board_users` WHERE `share_board_users`.`name` = '都賀町えいだ' LIMIT 1
# >>   ↳ app/models/share_board/user.rb:48:in `fetch'
# >>   TRANSACTION (0.2ms)  BEGIN
# >>   ↳ app/models/share_board/user.rb:48:in `fetch'
# >>   ShareBoard::User Exists? (0.3ms)  SELECT 1 AS one FROM `share_board_users` WHERE `share_board_users`.`name` = '都賀町えいだ' LIMIT 1
# >>   ↳ app/models/share_board/user.rb:48:in `fetch'
# >>   ShareBoard::User Create (0.4ms)  INSERT INTO `share_board_users` (`name`, `memberships_count`, `created_at`, `updated_at`, `chat_messages_count`) VALUES ('都賀町えいだ', 0, '2024-03-08 05:55:03', '2024-03-08 05:55:03', 0)
# >>   ↳ app/models/share_board/user.rb:48:in `fetch'
# >>   TRANSACTION (1.5ms)  COMMIT
# >>   ↳ app/models/share_board/user.rb:48:in `fetch'
# >>   ShareBoard::Room Load (1.0ms)  SELECT `share_board_rooms`.* FROM `share_board_rooms` WHERE `share_board_rooms`.`key` = 'dns' LIMIT 1
# >>   ↳ app/models/share_board/room.rb:20:in `fetch'
# >>   TRANSACTION (0.2ms)  BEGIN
# >>   ↳ app/models/share_board/room.rb:20:in `fetch'
# >>   ShareBoard::Room Create (0.6ms)  INSERT INTO `share_board_rooms` (`key`, `battles_count`, `created_at`, `updated_at`, `chat_messages_count`) VALUES ('dns', 0, '2024-03-08 05:55:03', '2024-03-08 05:55:03', 0)
# >>   ↳ app/models/share_board/room.rb:20:in `fetch'
# >>   TRANSACTION (1.0ms)  COMMIT
# >>   ↳ app/models/share_board/room.rb:20:in `fetch'
# >>   Location Load (0.2ms)  SELECT `locations`.* FROM `locations` WHERE `locations`.`key` = 'black' ORDER BY `locations`.`position` ASC LIMIT 1
# >>   ↳ app/models/concerns/memory_record_bind.rb:77:in `lookup'
# >>   TRANSACTION (0.2ms)  BEGIN
# >>   ↳ app/models/share_board/battle_create.rb:16:in `call'
# >>   ShareBoard::Battle Load (1.4ms)  SELECT `share_board_battles`.* FROM `share_board_battles` WHERE `share_board_battles`.`room_id` = 1 AND (`share_board_battles`.`position` IS NOT NULL) ORDER BY `share_board_battles`.`position` DESC LIMIT 1
# >>   ↳ app/models/share_board/battle_create.rb:16:in `call'
# >>   ShareBoard::Battle Create (0.5ms)  INSERT INTO `share_board_battles` (`room_id`, `key`, `title`, `sfen`, `turn`, `win_location_id`, `position`, `created_at`, `updated_at`) VALUES (1, '2a79cd9ee843b93630aa401f0a070eed', '共有将棋盤', 'position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d 2g2f 4c4d 3i4h 1c1d 1g1f 9c9d 9g9f 8b4b 2f2e 2b3c 5i6h 5a6b 6h7h 4a5b 4i5h 3a3b 5g5f 6b7b 4h5g 7b8b 3g3f 7a7b 6i6h 4d4e 2i3g 3c8h+ 7i8h 3b3c 5f5e 3d3e 3f3e 1d1e 2e2d 3c2d B*3d 4e4f 4g4f 4b2b 5e5d 2d3e 5d5c+ 5b5c 3g4e 5c5b P*5d P*5f 5g4h 3e4d 5d5c+ 4d5c 4e5c+ 5b5c 3d2c+ 2b2c 2h2c+ P*4c 2c2a B*1b 2a1b 1a1b R*2a 5f5g+ 4h5g P*5a 9f9e R*3i B*1g 3i3b+ 1g5c+ 3b2a N*9c B*4d 9c8a+ 7b8a 5c4c 4d8h+ 7h8h 2a2i 4c6a S*7i 8h9g N*8e 9g8f N*7d 8f7e 2i2e N*6e 7i6h B*7a', 91, 1, 0, '2024-03-08 05:55:03', '2024-03-08 05:55:03')
# >>   ↳ app/models/share_board/battle_create.rb:16:in `call'
# >>   ShareBoard::Room Update All (0.5ms)  UPDATE `share_board_rooms` SET `share_board_rooms`.`battles_count` = COALESCE(`share_board_rooms`.`battles_count`, 0) + 1, `share_board_rooms`.`updated_at` = '2024-03-08 05:55:03' WHERE `share_board_rooms`.`id` = 1
# >>   ↳ app/models/share_board/battle_create.rb:16:in `call'
# >>   ShareBoard::Room Load (0.3ms)  SELECT `share_board_rooms`.* FROM `share_board_rooms` WHERE `share_board_rooms`.`id` = 1 LIMIT 1
# >>   ↳ app/models/share_board/battle.rb:52:in `block in <class:Battle>'
# >>   ShareBoard::Roomship Load (3.3ms)  SELECT `share_board_roomships`.* FROM `share_board_roomships` WHERE `share_board_roomships`.`room_id` = 1 ORDER BY `share_board_roomships`.`rank` ASC
# >>   ↳ app/models/share_board/battle.rb:52:in `block in <class:Battle>'
# >>   TRANSACTION (0.8ms)  COMMIT
# >>   ↳ app/models/share_board/battle_create.rb:16:in `call'
# >>   ShareBoard::User Load (0.3ms)  SELECT `share_board_users`.* FROM `share_board_users` WHERE `share_board_users`.`name` = '電子れいず' LIMIT 1
# >>   ↳ app/models/share_board/user.rb:44:in `lookup'
# >>   Location Load (0.3ms)  SELECT `locations`.* FROM `locations` WHERE `locations`.`key` = 'black' ORDER BY `locations`.`position` ASC LIMIT 1
# >>   ↳ app/models/concerns/memory_record_bind.rb:77:in `lookup'
# >>   Judge Load (0.3ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`key` = 'win' ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/concerns/memory_record_bind.rb:77:in `lookup'
# >>   TRANSACTION (0.2ms)  BEGIN
# >>   ↳ app/models/share_board/battle_create.rb:17:in `call'
# >>   ShareBoard::Membership Exists? (1.2ms)  SELECT 1 AS one FROM `share_board_memberships` WHERE `share_board_memberships`.`user_id` = 1 AND `share_board_memberships`.`battle_id` = 1 LIMIT 1
# >>   ↳ app/models/share_board/battle_create.rb:17:in `call'
# >>   ShareBoard::Membership Load (0.4ms)  SELECT `share_board_memberships`.* FROM `share_board_memberships` WHERE `share_board_memberships`.`battle_id` = 1 AND (`share_board_memberships`.`position` IS NOT NULL) ORDER BY `share_board_memberships`.`position` DESC LIMIT 1
# >>   ↳ app/models/share_board/battle_create.rb:17:in `call'
# >>   ShareBoard::Membership Create (0.4ms)  INSERT INTO `share_board_memberships` (`battle_id`, `user_id`, `judge_id`, `location_id`, `position`, `created_at`, `updated_at`) VALUES (1, 1, 1, 1, 0, '2024-03-08 05:55:03', '2024-03-08 05:55:03')
# >>   ↳ app/models/share_board/battle_create.rb:17:in `call'
# >>   ShareBoard::User Update All (0.4ms)  UPDATE `share_board_users` SET `share_board_users`.`memberships_count` = COALESCE(`share_board_users`.`memberships_count`, 0) + 1, `share_board_users`.`updated_at` = '2024-03-08 05:55:03' WHERE `share_board_users`.`id` = 1
# >>   ↳ app/models/share_board/battle_create.rb:17:in `call'
# >>   ShareBoard::Room Load (0.6ms)  SELECT `share_board_rooms`.* FROM `share_board_rooms` INNER JOIN `share_board_battles` ON `share_board_rooms`.`id` = `share_board_battles`.`room_id` WHERE `share_board_battles`.`id` = 1 LIMIT 1
# >>   ↳ app/models/share_board/membership.rb:50:in `zadd_call'
# >>   ShareBoard::Roomship Load (0.4ms)  SELECT `share_board_roomships`.* FROM `share_board_roomships` WHERE `share_board_roomships`.`room_id` = 1 AND `share_board_roomships`.`user_id` = 1 ORDER BY `share_board_roomships`.`rank` ASC LIMIT 1
# >>   ↳ app/models/share_board/membership.rb:50:in `zadd_call'
# >>   Judge Load (0.4ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`key` = 'win' ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:22:in `db_record!'
# >>   ShareBoard::Membership Count (0.6ms)  SELECT COUNT(*) FROM `share_board_memberships` INNER JOIN `share_board_battles` ON `share_board_memberships`.`battle_id` = `share_board_battles`.`id` WHERE `share_board_battles`.`room_id` = 1 AND `share_board_memberships`.`user_id` = 1 AND `share_board_memberships`.`judge_id` = 1
# >>   ↳ app/models/share_board/room.rb:80:in `ox_count_by_user'
# >>   Judge Load (0.3ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`key` = 'lose' ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:22:in `db_record!'
# >>   ShareBoard::Membership Count (0.4ms)  SELECT COUNT(*) FROM `share_board_memberships` INNER JOIN `share_board_battles` ON `share_board_memberships`.`battle_id` = `share_board_battles`.`id` WHERE `share_board_battles`.`room_id` = 1 AND `share_board_memberships`.`user_id` = 1 AND `share_board_memberships`.`judge_id` = 2
# >>   ↳ app/models/share_board/room.rb:80:in `ox_count_by_user'
# >>   ShareBoard::Roomship Create (0.4ms)  INSERT INTO `share_board_roomships` (`room_id`, `user_id`, `win_count`, `lose_count`, `battles_count`, `win_rate`, `score`, `rank`, `created_at`, `updated_at`) VALUES (1, 1, 1, 0, 1, 1.0, 1, -1, '2024-03-08 05:55:03', '2024-03-08 05:55:03')
# >>   ↳ app/models/share_board/membership.rb:53:in `zadd_call'
# >>   TRANSACTION (1.9ms)  COMMIT
# >>   ↳ app/models/share_board/battle_create.rb:17:in `call'
# >>   ShareBoard::User Load (0.9ms)  SELECT `share_board_users`.* FROM `share_board_users` WHERE `share_board_users`.`name` = '都賀町えいだ' LIMIT 1
# >>   ↳ app/models/share_board/user.rb:44:in `lookup'
# >>   Location Load (0.4ms)  SELECT `locations`.* FROM `locations` WHERE `locations`.`key` = 'white' ORDER BY `locations`.`position` ASC LIMIT 1
# >>   ↳ app/models/concerns/memory_record_bind.rb:77:in `lookup'
# >>   Judge Load (0.3ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`key` = 'lose' ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/concerns/memory_record_bind.rb:77:in `lookup'
# >>   TRANSACTION (0.4ms)  BEGIN
# >>   ↳ app/models/share_board/battle_create.rb:17:in `call'
# >>   ShareBoard::Membership Exists? (0.5ms)  SELECT 1 AS one FROM `share_board_memberships` WHERE `share_board_memberships`.`user_id` = 2 AND `share_board_memberships`.`battle_id` = 1 LIMIT 1
# >>   ↳ app/models/share_board/battle_create.rb:17:in `call'
# >>   ShareBoard::Membership Load (0.4ms)  SELECT `share_board_memberships`.* FROM `share_board_memberships` WHERE `share_board_memberships`.`battle_id` = 1 AND (`share_board_memberships`.`position` IS NOT NULL) ORDER BY `share_board_memberships`.`position` DESC LIMIT 1
# >>   ↳ app/models/share_board/battle_create.rb:17:in `call'
# >>   ShareBoard::Membership Create (0.5ms)  INSERT INTO `share_board_memberships` (`battle_id`, `user_id`, `judge_id`, `location_id`, `position`, `created_at`, `updated_at`) VALUES (1, 2, 2, 2, 1, '2024-03-08 05:55:08', '2024-03-08 05:55:08')
# >>   ↳ app/models/share_board/battle_create.rb:17:in `call'
# >>   ShareBoard::User Update All (0.5ms)  UPDATE `share_board_users` SET `share_board_users`.`memberships_count` = COALESCE(`share_board_users`.`memberships_count`, 0) + 1, `share_board_users`.`updated_at` = '2024-03-08 05:55:08' WHERE `share_board_users`.`id` = 2
# >>   ↳ app/models/share_board/battle_create.rb:17:in `call'
# >>   ShareBoard::Room Load (0.4ms)  SELECT `share_board_rooms`.* FROM `share_board_rooms` INNER JOIN `share_board_battles` ON `share_board_rooms`.`id` = `share_board_battles`.`room_id` WHERE `share_board_battles`.`id` = 1 LIMIT 1
# >>   ↳ app/models/share_board/membership.rb:50:in `zadd_call'
# >>   ShareBoard::Roomship Load (0.4ms)  SELECT `share_board_roomships`.* FROM `share_board_roomships` WHERE `share_board_roomships`.`room_id` = 1 AND `share_board_roomships`.`user_id` = 2 ORDER BY `share_board_roomships`.`rank` ASC LIMIT 1
# >>   ↳ app/models/share_board/membership.rb:50:in `zadd_call'
# >>   Judge Load (0.4ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`key` = 'win' ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:22:in `db_record!'
# >>   ShareBoard::Membership Count (0.7ms)  SELECT COUNT(*) FROM `share_board_memberships` INNER JOIN `share_board_battles` ON `share_board_memberships`.`battle_id` = `share_board_battles`.`id` WHERE `share_board_battles`.`room_id` = 1 AND `share_board_memberships`.`user_id` = 2 AND `share_board_memberships`.`judge_id` = 1
# >>   ↳ app/models/share_board/room.rb:80:in `ox_count_by_user'
# >>   Judge Load (0.3ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`key` = 'lose' ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:22:in `db_record!'
# >>   ShareBoard::Membership Count (0.3ms)  SELECT COUNT(*) FROM `share_board_memberships` INNER JOIN `share_board_battles` ON `share_board_memberships`.`battle_id` = `share_board_battles`.`id` WHERE `share_board_battles`.`room_id` = 1 AND `share_board_memberships`.`user_id` = 2 AND `share_board_memberships`.`judge_id` = 2
# >>   ↳ app/models/share_board/room.rb:80:in `ox_count_by_user'
# >>   ShareBoard::Roomship Create (0.4ms)  INSERT INTO `share_board_roomships` (`room_id`, `user_id`, `win_count`, `lose_count`, `battles_count`, `win_rate`, `score`, `rank`, `created_at`, `updated_at`) VALUES (1, 2, 0, 1, 1, 0.0, 0, -1, '2024-03-08 05:55:08', '2024-03-08 05:55:08')
# >>   ↳ app/models/share_board/membership.rb:53:in `zadd_call'
# >>   TRANSACTION (1.9ms)  COMMIT
# >>   ↳ app/models/share_board/battle_create.rb:17:in `call'
# >> |---------------------+---------------------------|
# >> |                  id | 1                         |
# >> |                 key | dns                       |
# >> |       battles_count | 1                         |
# >> |          created_at | 2024-03-08 14:55:03 +0900 |
# >> |          updated_at | 2024-03-08 14:55:03 +0900 |
# >> | chat_messages_count | 0                         |
# >> |---------------------+---------------------------|
# >> |-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |              id | 1                                                                                                                                                                                                                                                                   |
# >> |         room_id | 1                                                                                                                                                                                                                                                                   |
# >> |             key | 2a79cd9ee843b93630aa401f0a070eed                                                                                                                                                                                                                                    |
# >> |           title | 共有将棋盤                                                                                                                                                                                                                                                          |
# >> |            sfen | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d 2g2f 4c4d 3i4h 1c1d 1g1f 9c9d 9g9f 8b4b 2f2e 2b3c 5i6h 5a6b 6h7h 4a5b 4i5h 3a3b 5g5f 6b7b 4h5g 7b8b 3g3f 7a7b 6i6h 4d4e 2i3g 3c8h+ 7i8h 3b3c 5f5e 3d3e 3f3e 1d1e 2... |
# >> |            turn | 91                                                                                                                                                                                                                                                                  |
# >> | win_location_id | 1                                                                                                                                                                                                                                                                   |
# >> |        position | 0                                                                                                                                                                                                                                                                   |
# >> |      created_at | 2024-03-08 14:55:03 +0900                                                                                                                                                                                                                                           |
# >> |      updated_at | 2024-03-08 14:55:03 +0900                                                                                                                                                                                                                                           |
# >> |-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >>   ShareBoard::Membership Load (0.9ms)  SELECT `share_board_memberships`.* FROM `share_board_memberships` WHERE `share_board_memberships`.`battle_id` = 1 ORDER BY `share_board_memberships`.`position` ASC
# >> |----+-----------+---------+----------+-------------+----------+---------------------------+---------------------------|
# >> | id | battle_id | user_id | judge_id | location_id | position | created_at                | updated_at                |
# >> |----+-----------+---------+----------+-------------+----------+---------------------------+---------------------------|
# >> |  1 |         1 |       1 |        1 |           1 |        0 | 2024-03-08 14:55:03 +0900 | 2024-03-08 14:55:03 +0900 |
# >> |  2 |         1 |       2 |        2 |           2 |        1 | 2024-03-08 14:55:08 +0900 | 2024-03-08 14:55:08 +0900 |
# >> |----+-----------+---------+----------+-------------+----------+---------------------------+---------------------------|
# >>   ShareBoard::User Load (1.0ms)  SELECT `share_board_users`.* FROM `share_board_users` INNER JOIN `share_board_memberships` ON `share_board_users`.`id` = `share_board_memberships`.`user_id` INNER JOIN `share_board_battles` ON `share_board_memberships`.`battle_id` = `share_board_battles`.`id` WHERE `share_board_battles`.`room_id` = 1 ORDER BY `share_board_memberships`.`position` ASC, `share_board_battles`.`created_at` DESC
# >> |----+--------------+-------------------+---------------------------+---------------------------+---------------------|
# >> | id | name         | memberships_count | created_at                | updated_at                | chat_messages_count |
# >> |----+--------------+-------------------+---------------------------+---------------------------+---------------------|
# >> |  1 | 電子れいず   |                 1 | 2024-03-08 14:55:03 +0900 | 2024-03-08 14:55:03 +0900 |                   0 |
# >> |  2 | 都賀町えいだ |                 1 | 2024-03-08 14:55:03 +0900 | 2024-03-08 14:55:08 +0900 |                   0 |
# >> |----+--------------+-------------------+---------------------------+---------------------------+---------------------|
