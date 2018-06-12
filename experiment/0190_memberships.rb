#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

ChatMessage.destroy_all
User.destroy_all
BattleRoom.destroy_all
Membership.destroy_all

alice = User.create!
bob = User.create!

ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
ActiveSupport::LogSubscriber.colorize_logging = false

users = [alice, bob]
battle_room = OwnerRoom.create!(users: users)

tp Membership.all
# >>    (0.2ms)  BEGIN
# >>   SQL (0.6ms)  INSERT INTO `battle_rooms` (`room_owner_id`, `self_preset_key`, `oppo_preset_key`, `lifetime_key`, `name`, `kifu_body_sfen`, `clock_counts`, `turn_max`, `created_at`, `updated_at`) VALUES (35, '平手', '平手', 'lifetime_m5', '野良1号 vs 野良2号', 'position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1', '---\n:black: []\n:white: []\n', 0, '2018-05-06 09:52:40', '2018-05-06 09:52:40')
# >> nil
# >>   Membership Load (0.4ms)  SELECT  `memberships`.* FROM `memberships` WHERE `memberships`.`battle_room_id` = 16 AND (`memberships`.`position` IS NOT NULL) ORDER BY `memberships`.`position` DESC LIMIT 1
# >>   SQL (0.2ms)  INSERT INTO `memberships` (`preset_key`, `battle_room_id`, `user_id`, `location_key`, `position`, `created_at`, `updated_at`) VALUES ('平手', 16, 35, 'black', 0, '2018-05-06 09:52:40', '2018-05-06 09:52:40')
# >> nil
# >>   Membership Load (0.5ms)  SELECT  `memberships`.* FROM `memberships` WHERE `memberships`.`battle_room_id` = 16 AND (`memberships`.`position` IS NOT NULL) ORDER BY `memberships`.`position` DESC LIMIT 1
# >>   SQL (0.2ms)  INSERT INTO `memberships` (`preset_key`, `battle_room_id`, `user_id`, `location_key`, `position`, `created_at`, `updated_at`) VALUES ('平手', 16, 36, 'white', 1, '2018-05-06 09:52:40', '2018-05-06 09:52:40')
# >>    (0.4ms)  COMMIT
# >>   BattleRoom Load (0.3ms)  SELECT  `battle_rooms`.* FROM `battle_rooms` ORDER BY `battle_rooms`.`updated_at` DESC LIMIT 50
# >>   User Load (0.3ms)  SELECT  `users`.* FROM `users` WHERE `users`.`id` = 35 LIMIT 1
# >>   User Load (0.6ms)  SELECT `users`.* FROM `users` INNER JOIN `memberships` ON `users`.`id` = `memberships`.`user_id` WHERE `memberships`.`battle_room_id` = 16 ORDER BY `memberships`.`position` ASC
# >>   User Load (0.4ms)  SELECT `users`.* FROM `users` INNER JOIN `watch_memberships` ON `users`.`id` = `watch_memberships`.`user_id` WHERE `watch_memberships`.`battle_room_id` = 16
# >>   User Load (0.5ms)  SELECT `users`.* FROM `users` INNER JOIN `watch_memberships` ON `users`.`id` = `watch_memberships`.`user_id` WHERE `watch_memberships`.`battle_room_id` = 16
# >>   Membership Load (0.5ms)  SELECT `memberships`.* FROM `memberships` ORDER BY `memberships`.`position` ASC
# >> |----+------------+--------------+--------------+--------------+----------+------------+-----------------+---------------------------+---------------------------|
# >> | id | preset_key | battle_room_id | user_id | location_key | position | standby_at | fighting_at | created_at                | updated_at                |
# >> |----+------------+--------------+--------------+--------------+----------+------------+-----------------+---------------------------+---------------------------|
# >> | 25 | 平手       |           16 |           35 | black        |        0 |            |                 | 2018-05-06 18:52:40 +0900 | 2018-05-06 18:52:40 +0900 |
# >> | 26 | 平手       |           16 |           36 | white        |        1 |            |                 | 2018-05-06 18:52:40 +0900 | 2018-05-06 18:52:40 +0900 |
# >> |----+------------+--------------+--------------+--------------+----------+------------+-----------------+---------------------------+---------------------------|
