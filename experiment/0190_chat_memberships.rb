#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

RoomChatMessage.destroy_all
ChatUser.destroy_all
ChatRoom.destroy_all
ChatMembership.destroy_all

alice = ChatUser.create!
bob = ChatUser.create!

ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
ActiveSupport::LogSubscriber.colorize_logging = false

chat_users = [alice, bob]
chat_room = OwnerRoom.create!(chat_users: chat_users)

tp ChatMembership.all
# >>    (0.2ms)  BEGIN
# >>   SQL (0.6ms)  INSERT INTO `chat_rooms` (`room_owner_id`, `ps_preset_key`, `po_preset_key`, `lifetime_key`, `name`, `kifu_body_sfen`, `clock_counts`, `turn_max`, `created_at`, `updated_at`) VALUES (35, '平手', '平手', 'lifetime_m5', '野良1号 vs 野良2号', 'position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1', '---\n:black: []\n:white: []\n', 0, '2018-05-06 09:52:40', '2018-05-06 09:52:40')
# >> nil
# >>   ChatMembership Load (0.4ms)  SELECT  `chat_memberships`.* FROM `chat_memberships` WHERE `chat_memberships`.`chat_room_id` = 16 AND (`chat_memberships`.`position` IS NOT NULL) ORDER BY `chat_memberships`.`position` DESC LIMIT 1
# >>   SQL (0.2ms)  INSERT INTO `chat_memberships` (`preset_key`, `chat_room_id`, `chat_user_id`, `location_key`, `position`, `created_at`, `updated_at`) VALUES ('平手', 16, 35, 'black', 0, '2018-05-06 09:52:40', '2018-05-06 09:52:40')
# >> nil
# >>   ChatMembership Load (0.5ms)  SELECT  `chat_memberships`.* FROM `chat_memberships` WHERE `chat_memberships`.`chat_room_id` = 16 AND (`chat_memberships`.`position` IS NOT NULL) ORDER BY `chat_memberships`.`position` DESC LIMIT 1
# >>   SQL (0.2ms)  INSERT INTO `chat_memberships` (`preset_key`, `chat_room_id`, `chat_user_id`, `location_key`, `position`, `created_at`, `updated_at`) VALUES ('平手', 16, 36, 'white', 1, '2018-05-06 09:52:40', '2018-05-06 09:52:40')
# >>    (0.4ms)  COMMIT
# >>   ChatRoom Load (0.3ms)  SELECT  `chat_rooms`.* FROM `chat_rooms` ORDER BY `chat_rooms`.`updated_at` DESC LIMIT 50
# >>   ChatUser Load (0.3ms)  SELECT  `chat_users`.* FROM `chat_users` WHERE `chat_users`.`id` = 35 LIMIT 1
# >>   ChatUser Load (0.6ms)  SELECT `chat_users`.* FROM `chat_users` INNER JOIN `chat_memberships` ON `chat_users`.`id` = `chat_memberships`.`chat_user_id` WHERE `chat_memberships`.`chat_room_id` = 16 ORDER BY `chat_memberships`.`position` ASC
# >>   ChatUser Load (0.4ms)  SELECT `chat_users`.* FROM `chat_users` INNER JOIN `watch_memberships` ON `chat_users`.`id` = `watch_memberships`.`chat_user_id` WHERE `watch_memberships`.`chat_room_id` = 16
# >>   ChatUser Load (0.5ms)  SELECT `chat_users`.* FROM `chat_users` INNER JOIN `watch_memberships` ON `chat_users`.`id` = `watch_memberships`.`chat_user_id` WHERE `watch_memberships`.`chat_room_id` = 16
# >>   ChatMembership Load (0.5ms)  SELECT `chat_memberships`.* FROM `chat_memberships` ORDER BY `chat_memberships`.`position` ASC
# >> |----+------------+--------------+--------------+--------------+----------+------------+-----------------+---------------------------+---------------------------|
# >> | id | preset_key | chat_room_id | chat_user_id | location_key | position | standby_at | fighting_now_at | created_at                | updated_at                |
# >> |----+------------+--------------+--------------+--------------+----------+------------+-----------------+---------------------------+---------------------------|
# >> | 25 | 平手       |           16 |           35 | black        |        0 |            |                 | 2018-05-06 18:52:40 +0900 | 2018-05-06 18:52:40 +0900 |
# >> | 26 | 平手       |           16 |           36 | white        |        1 |            |                 | 2018-05-06 18:52:40 +0900 | 2018-05-06 18:52:40 +0900 |
# >> |----+------------+--------------+--------------+--------------+----------+------------+-----------------+---------------------------+---------------------------|
