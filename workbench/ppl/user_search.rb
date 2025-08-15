require "#{__dir__}/setup"
Ppl.setup_for_workbench
Ppl::Updater.update_raw(5, { mentor: "X", name: "alice", })
Ppl::Updater.update_raw(6, { mentor: "Y", name: "bob",   })
Ppl::Updater.update_raw(7, { mentor: "Z", name: "carol", })
sql
Ppl::User.search(name: "a").collect(&:name)                    # => ["alice", "bob", "carol"]
Ppl::User.search(season_number: "6").collect(&:name)           # => ["bob"]
Ppl::User.search(mentor_name: "X").collect(&:name)             # => ["alice"]
Ppl::User.search(query: "a").collect(&:name)                   # => ["alice", "carol"]

Ppl.setup_for_workbench
Ppl::Updater.update_raw(5, { mentor: "X", name: "alice", })
Ppl::User.search(mentor_name: "X", query: "a").collect(&:name) # => ["alice"]
# >>   Ppl::User Load (0.3ms)  SELECT `ppl_users`.* FROM `ppl_users` WHERE `ppl_users`.`name` = 'a' /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/user_search.rb:23:in 'Ppl::UserSearch#call'
# >>   Ppl::User Load (0.4ms)  SELECT `ppl_users`.* FROM `ppl_users` ORDER BY promotion_season_number IS NULL, `ppl_users`.`promotion_season_number` ASC, `ppl_users`.`promotion_win` DESC, `ppl_users`.`runner_up_count` DESC, `ppl_users`.`age_min` ASC, `ppl_users`.`memberships_count` ASC /*application='ShogiWeb'*/
# >>   Ppl::Mentor Load (0.2ms)  SELECT `ppl_mentors`.* FROM `ppl_mentors` WHERE `ppl_mentors`.`id` IN (917, 918, 919) /*application='ShogiWeb'*/
# >>   Ppl::Membership Load (1.5ms)  SELECT `ppl_memberships`.* FROM `ppl_memberships` WHERE `ppl_memberships`.`user_id` IN (2171, 2172, 2173) /*application='ShogiWeb'*/
# >>   Ppl::LeagueSeason Load (0.3ms)  SELECT `ppl_league_seasons`.* FROM `ppl_league_seasons` WHERE `ppl_league_seasons`.`id` IN (540, 541, 542) /*application='ShogiWeb'*/
# >>   Ppl::Result Load (0.3ms)  SELECT `ppl_results`.* FROM `ppl_results` WHERE `ppl_results`.`id` = 4 ORDER BY `ppl_results`.`position` ASC /*application='ShogiWeb'*/
# >>   Ppl::LeagueSeason Load (0.3ms)  SELECT `ppl_league_seasons`.* FROM `ppl_league_seasons` WHERE `ppl_league_seasons`.`season_number` = 6 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/user_search.rb:34:in 'Ppl::UserSearch#call'
# >>   Ppl::User Pluck (0.4ms)  SELECT `ppl_users`.`id` FROM `ppl_users` INNER JOIN `ppl_memberships` ON `ppl_users`.`id` = `ppl_memberships`.`user_id` WHERE `ppl_memberships`.`league_season_id` = 541 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/user_search.rb:35:in 'block in Ppl::UserSearch#call'
# >>   Ppl::User Load (0.3ms)  SELECT `ppl_users`.* FROM `ppl_users` WHERE `ppl_users`.`id` = 2172 ORDER BY promotion_season_number IS NULL, `ppl_users`.`promotion_season_number` ASC, `ppl_users`.`promotion_win` DESC, `ppl_users`.`runner_up_count` DESC, `ppl_users`.`age_min` ASC, `ppl_users`.`memberships_count` ASC /*application='ShogiWeb'*/
# >>   Ppl::Mentor Load (0.2ms)  SELECT `ppl_mentors`.* FROM `ppl_mentors` WHERE `ppl_mentors`.`id` = 918 /*application='ShogiWeb'*/
# >>   Ppl::Membership Load (0.3ms)  SELECT `ppl_memberships`.* FROM `ppl_memberships` WHERE `ppl_memberships`.`user_id` = 2172 /*application='ShogiWeb'*/
# >>   Ppl::LeagueSeason Load (0.2ms)  SELECT `ppl_league_seasons`.* FROM `ppl_league_seasons` WHERE `ppl_league_seasons`.`id` = 541 /*application='ShogiWeb'*/
# >>   Ppl::Result Load (0.2ms)  SELECT `ppl_results`.* FROM `ppl_results` WHERE `ppl_results`.`id` = 4 ORDER BY `ppl_results`.`position` ASC /*application='ShogiWeb'*/
# >>   Ppl::Mentor Load (0.3ms)  SELECT `ppl_mentors`.* FROM `ppl_mentors` WHERE `ppl_mentors`.`name` = 'X' /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/user_search.rb:29:in 'Ppl::UserSearch#call'
# >>   Ppl::User Load (0.4ms)  SELECT `ppl_users`.* FROM `ppl_users` INNER JOIN `ppl_mentors` ON `ppl_mentors`.`id` = `ppl_users`.`mentor_id` WHERE `ppl_mentors`.`name` = 'X' ORDER BY promotion_season_number IS NULL, `ppl_users`.`promotion_season_number` ASC, `ppl_users`.`promotion_win` DESC, `ppl_users`.`runner_up_count` DESC, `ppl_users`.`age_min` ASC, `ppl_users`.`memberships_count` ASC /*application='ShogiWeb'*/
# >>   Ppl::Mentor Load (0.2ms)  SELECT `ppl_mentors`.* FROM `ppl_mentors` WHERE `ppl_mentors`.`id` = 917 /*application='ShogiWeb'*/
# >>   Ppl::Membership Load (0.3ms)  SELECT `ppl_memberships`.* FROM `ppl_memberships` WHERE `ppl_memberships`.`user_id` = 2171 /*application='ShogiWeb'*/
# >>   Ppl::LeagueSeason Load (0.2ms)  SELECT `ppl_league_seasons`.* FROM `ppl_league_seasons` WHERE `ppl_league_seasons`.`id` = 540 /*application='ShogiWeb'*/
# >>   Ppl::Result Load (0.3ms)  SELECT `ppl_results`.* FROM `ppl_results` WHERE `ppl_results`.`id` = 4 ORDER BY `ppl_results`.`position` ASC /*application='ShogiWeb'*/
# >>   Ppl::User Load (0.4ms)  SELECT `ppl_users`.* FROM `ppl_users` WHERE ( (LOWER(ppl_users.name) LIKE '%a%')) ORDER BY promotion_season_number IS NULL, `ppl_users`.`promotion_season_number` ASC, `ppl_users`.`promotion_win` DESC, `ppl_users`.`runner_up_count` DESC, `ppl_users`.`age_min` ASC, `ppl_users`.`memberships_count` ASC /*application='ShogiWeb'*/
# >>   Ppl::Mentor Load (0.3ms)  SELECT `ppl_mentors`.* FROM `ppl_mentors` WHERE `ppl_mentors`.`id` IN (917, 919) /*application='ShogiWeb'*/
# >>   Ppl::Membership Load (0.5ms)  SELECT `ppl_memberships`.* FROM `ppl_memberships` WHERE `ppl_memberships`.`user_id` IN (2171, 2173) /*application='ShogiWeb'*/
# >>   Ppl::LeagueSeason Load (0.2ms)  SELECT `ppl_league_seasons`.* FROM `ppl_league_seasons` WHERE `ppl_league_seasons`.`id` IN (540, 542) /*application='ShogiWeb'*/
# >>   Ppl::Result Load (0.3ms)  SELECT `ppl_results`.* FROM `ppl_results` WHERE `ppl_results`.`id` = 4 ORDER BY `ppl_results`.`position` ASC /*application='ShogiWeb'*/
# >>   Ppl::LeagueSeason Load (0.3ms)  SELECT `ppl_league_seasons`.* FROM `ppl_league_seasons` /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   TRANSACTION (0.4ms)  BEGIN /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::Membership Load (1.3ms)  SELECT `ppl_memberships`.* FROM `ppl_memberships` WHERE `ppl_memberships`.`league_season_id` = 540 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::Membership Destroy (0.4ms)  DELETE FROM `ppl_memberships` WHERE `ppl_memberships`.`id` = 14111 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::User Update All (0.4ms)  UPDATE `ppl_users` SET `ppl_users`.`memberships_count` = COALESCE(`ppl_users`.`memberships_count`, 0) - 1 WHERE `ppl_users`.`id` = 2171 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::LeagueSeason Destroy (0.3ms)  DELETE FROM `ppl_league_seasons` WHERE `ppl_league_seasons`.`id` = 540 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   TRANSACTION (0.5ms)  COMMIT /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   TRANSACTION (0.2ms)  BEGIN /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::Membership Load (0.8ms)  SELECT `ppl_memberships`.* FROM `ppl_memberships` WHERE `ppl_memberships`.`league_season_id` = 541 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::Membership Destroy (0.3ms)  DELETE FROM `ppl_memberships` WHERE `ppl_memberships`.`id` = 14112 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::User Update All (0.3ms)  UPDATE `ppl_users` SET `ppl_users`.`memberships_count` = COALESCE(`ppl_users`.`memberships_count`, 0) - 1 WHERE `ppl_users`.`id` = 2172 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::LeagueSeason Destroy (0.3ms)  DELETE FROM `ppl_league_seasons` WHERE `ppl_league_seasons`.`id` = 541 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   TRANSACTION (0.6ms)  COMMIT /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   TRANSACTION (0.1ms)  BEGIN /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::Membership Load (0.8ms)  SELECT `ppl_memberships`.* FROM `ppl_memberships` WHERE `ppl_memberships`.`league_season_id` = 542 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::Membership Destroy (0.3ms)  DELETE FROM `ppl_memberships` WHERE `ppl_memberships`.`id` = 14113 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::User Update All (0.3ms)  UPDATE `ppl_users` SET `ppl_users`.`memberships_count` = COALESCE(`ppl_users`.`memberships_count`, 0) - 1 WHERE `ppl_users`.`id` = 2173 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::LeagueSeason Destroy (0.3ms)  DELETE FROM `ppl_league_seasons` WHERE `ppl_league_seasons`.`id` = 542 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   TRANSACTION (0.6ms)  COMMIT /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::User Load (0.3ms)  SELECT `ppl_users`.* FROM `ppl_users` /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   TRANSACTION (0.2ms)  BEGIN /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::Membership Load (0.8ms)  SELECT `ppl_memberships`.* FROM `ppl_memberships` WHERE `ppl_memberships`.`user_id` = 2171 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::User Destroy (0.3ms)  DELETE FROM `ppl_users` WHERE `ppl_users`.`id` = 2171 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::Mentor Update All (0.3ms)  UPDATE `ppl_mentors` SET `ppl_mentors`.`users_count` = COALESCE(`ppl_mentors`.`users_count`, 0) - 1 WHERE `ppl_mentors`.`id` = 917 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   TRANSACTION (0.5ms)  COMMIT /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   TRANSACTION (0.2ms)  BEGIN /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::Membership Load (0.8ms)  SELECT `ppl_memberships`.* FROM `ppl_memberships` WHERE `ppl_memberships`.`user_id` = 2172 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::User Destroy (0.3ms)  DELETE FROM `ppl_users` WHERE `ppl_users`.`id` = 2172 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::Mentor Update All (0.3ms)  UPDATE `ppl_mentors` SET `ppl_mentors`.`users_count` = COALESCE(`ppl_mentors`.`users_count`, 0) - 1 WHERE `ppl_mentors`.`id` = 918 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   TRANSACTION (0.5ms)  COMMIT /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   TRANSACTION (0.1ms)  BEGIN /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::Membership Load (0.8ms)  SELECT `ppl_memberships`.* FROM `ppl_memberships` WHERE `ppl_memberships`.`user_id` = 2173 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::User Destroy (0.3ms)  DELETE FROM `ppl_users` WHERE `ppl_users`.`id` = 2173 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::Mentor Update All (0.3ms)  UPDATE `ppl_mentors` SET `ppl_mentors`.`users_count` = COALESCE(`ppl_mentors`.`users_count`, 0) - 1 WHERE `ppl_mentors`.`id` = 919 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   TRANSACTION (0.5ms)  COMMIT /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::Mentor Load (0.2ms)  SELECT `ppl_mentors`.* FROM `ppl_mentors` /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   TRANSACTION (0.1ms)  BEGIN /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::User Load (0.8ms)  SELECT `ppl_users`.* FROM `ppl_users` WHERE `ppl_users`.`mentor_id` = 917 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::Mentor Destroy (0.3ms)  DELETE FROM `ppl_mentors` WHERE `ppl_mentors`.`id` = 917 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   TRANSACTION (0.5ms)  COMMIT /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   TRANSACTION (0.2ms)  BEGIN /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::User Load (0.9ms)  SELECT `ppl_users`.* FROM `ppl_users` WHERE `ppl_users`.`mentor_id` = 918 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::Mentor Destroy (0.3ms)  DELETE FROM `ppl_mentors` WHERE `ppl_mentors`.`id` = 918 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   TRANSACTION (0.5ms)  COMMIT /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   TRANSACTION (0.2ms)  BEGIN /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::User Load (0.9ms)  SELECT `ppl_users`.* FROM `ppl_users` WHERE `ppl_users`.`mentor_id` = 919 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::Mentor Destroy (0.3ms)  DELETE FROM `ppl_mentors` WHERE `ppl_mentors`.`id` = 919 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   TRANSACTION (0.5ms)  COMMIT /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl.rb:20:in 'Array#each'
# >>   Ppl::Result Load (0.3ms)  SELECT `ppl_results`.* FROM `ppl_results` WHERE `ppl_results`.`key` = 'promotion' ORDER BY `ppl_results`.`position` ASC LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/concerns/memory_record_bind.rb:36:in 'block in MemoryRecordBind::Base::ClassMethods#setup'
# >>   Ppl::Result Load (0.3ms)  SELECT `ppl_results`.* FROM `ppl_results` WHERE `ppl_results`.`key` = 'demotion' ORDER BY `ppl_results`.`position` ASC LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/concerns/memory_record_bind.rb:36:in 'block in MemoryRecordBind::Base::ClassMethods#setup'
# >>   Ppl::Result Load (0.3ms)  SELECT `ppl_results`.* FROM `ppl_results` WHERE `ppl_results`.`key` = 'runner_up' ORDER BY `ppl_results`.`position` ASC LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/concerns/memory_record_bind.rb:36:in 'block in MemoryRecordBind::Base::ClassMethods#setup'
# >>   Ppl::Result Load (0.3ms)  SELECT `ppl_results`.* FROM `ppl_results` WHERE `ppl_results`.`key` = 'retain' ORDER BY `ppl_results`.`position` ASC LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/concerns/memory_record_bind.rb:36:in 'block in MemoryRecordBind::Base::ClassMethods#setup'
# >>   Ppl::LeagueSeason Load (0.3ms)  SELECT `ppl_league_seasons`.* FROM `ppl_league_seasons` WHERE `ppl_league_seasons`.`season_number` = 5 LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/updater.rb:35:in 'Ppl::Updater#update_raw'
# >>   TRANSACTION (0.2ms)  BEGIN /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/updater.rb:35:in 'Ppl::Updater#update_raw'
# >>   Ppl::LeagueSeason Create (1.0ms)  INSERT INTO `ppl_league_seasons` (`season_number`, `created_at`, `updated_at`) VALUES (5, '2025-08-15 06:28:26.297967', '2025-08-15 06:28:26.297967') /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/updater.rb:35:in 'Ppl::Updater#update_raw'
# >>   TRANSACTION (0.5ms)  COMMIT /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/updater.rb:35:in 'Ppl::Updater#update_raw'
# >>   Ppl::User Load (0.3ms)  SELECT `ppl_users`.* FROM `ppl_users` WHERE `ppl_users`.`name` = 'alice' LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/updater.rb:37:in 'block in Ppl::Updater#update_raw'
# >>   TRANSACTION (0.2ms)  BEGIN /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/updater.rb:37:in 'block in Ppl::Updater#update_raw'
# >>   Ppl::User Exists? (0.9ms)  SELECT 1 AS one FROM `ppl_users` WHERE `ppl_users`.`name` = 'alice' LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/updater.rb:37:in 'block in Ppl::Updater#update_raw'
# >>   Ppl::User Create (0.4ms)  INSERT INTO `ppl_users` (`mentor_id`, `name`, `age_min`, `age_max`, `runner_up_count`, `win_max`, `promotion_membership_id`, `promotion_season_number`, `promotion_win`, `memberships_first_id`, `season_number_min`, `memberships_last_id`, `season_number_max`, `memberships_count`, `created_at`, `updated_at`) VALUES (NULL, 'alice', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '2025-08-15 06:28:26.303959', '2025-08-15 06:28:26.303959') /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/updater.rb:37:in 'block in Ppl::Updater#update_raw'
# >>   TRANSACTION (1.0ms)  COMMIT /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/updater.rb:37:in 'block in Ppl::Updater#update_raw'
# >>   Ppl::Mentor Load (0.2ms)  SELECT `ppl_mentors`.* FROM `ppl_mentors` WHERE `ppl_mentors`.`name` = 'X' LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/updater.rb:42:in 'block in Ppl::Updater#update_raw'
# >>   TRANSACTION (0.2ms)  BEGIN /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/updater.rb:42:in 'block in Ppl::Updater#update_raw'
# >>   Ppl::Mentor Exists? (0.9ms)  SELECT 1 AS one FROM `ppl_mentors` WHERE `ppl_mentors`.`name` = 'X' LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/updater.rb:42:in 'block in Ppl::Updater#update_raw'
# >>   Ppl::Mentor Create (0.3ms)  INSERT INTO `ppl_mentors` (`name`, `users_count`, `created_at`, `updated_at`) VALUES ('X', 0, '2025-08-15 06:28:26.309828', '2025-08-15 06:28:26.309828') /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/updater.rb:42:in 'block in Ppl::Updater#update_raw'
# >>   TRANSACTION (0.5ms)  COMMIT /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/updater.rb:42:in 'block in Ppl::Updater#update_raw'
# >>   TRANSACTION (0.2ms)  BEGIN /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/updater.rb:42:in 'block in Ppl::Updater#update_raw'
# >>   Ppl::User Update (1.0ms)  UPDATE `ppl_users` SET `ppl_users`.`mentor_id` = 920, `ppl_users`.`updated_at` = '2025-08-15 06:28:26.312202' WHERE `ppl_users`.`id` = 2174 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/updater.rb:42:in 'block in Ppl::Updater#update_raw'
# >>   Ppl::Mentor Update All (0.3ms)  UPDATE `ppl_mentors` SET `ppl_mentors`.`users_count` = COALESCE(`ppl_mentors`.`users_count`, 0) + 1 WHERE `ppl_mentors`.`id` = 920 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/updater.rb:42:in 'block in Ppl::Updater#update_raw'
# >>   TRANSACTION (0.5ms)  COMMIT /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/updater.rb:42:in 'block in Ppl::Updater#update_raw'
# >>   Ppl::Membership Load (0.3ms)  SELECT `ppl_memberships`.* FROM `ppl_memberships` WHERE `ppl_memberships`.`user_id` = 2174 AND `ppl_memberships`.`league_season_id` = 543 LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/updater.rb:45:in 'block in Ppl::Updater#update_raw'
# >>   TRANSACTION (0.2ms)  BEGIN /*application='ShogiWeb'*/
# >>   ↳ app/models/application_memory_record.rb:36:in 'ApplicationMemoryRecord#db_record!'
# >>   Ppl::Result Load (0.7ms)  SELECT `ppl_results`.* FROM `ppl_results` WHERE `ppl_results`.`key` = 'retain' ORDER BY `ppl_results`.`position` ASC LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/application_memory_record.rb:36:in 'ApplicationMemoryRecord#db_record!'
# >>   Ppl::Result Load (0.3ms)  SELECT `ppl_results`.* FROM `ppl_results` WHERE `ppl_results`.`id` = 4 ORDER BY `ppl_results`.`position` ASC LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/updater.rb:46:in 'block in Ppl::Updater#update_raw'
# >>   Ppl::Membership Create (0.3ms)  INSERT INTO `ppl_memberships` (`league_season_id`, `user_id`, `result_id`, `start_pos`, `age`, `win`, `lose`, `ox`, `created_at`, `updated_at`) VALUES (543, 2174, 4, 0, NULL, 0, 0, '', '2025-08-15 06:28:26.322685', '2025-08-15 06:28:26.322685') /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/updater.rb:46:in 'block in Ppl::Updater#update_raw'
# >>   Ppl::User Update All (0.3ms)  UPDATE `ppl_users` SET `ppl_users`.`memberships_count` = COALESCE(`ppl_users`.`memberships_count`, 0) + 1 WHERE `ppl_users`.`id` = 2174 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/updater.rb:46:in 'block in Ppl::Updater#update_raw'
# >>   Ppl::Membership Load (0.3ms)  SELECT `ppl_memberships`.* FROM `ppl_memberships` WHERE `ppl_memberships`.`user_id` = 2174 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/membership.rb:66:in 'Enumerable#minmax_by'
# >>   Ppl::User Update (0.4ms)  UPDATE `ppl_users` SET `ppl_users`.`memberships_first_id` = 14114, `ppl_users`.`season_number_min` = 5, `ppl_users`.`memberships_last_id` = 14114, `ppl_users`.`season_number_max` = 5, `ppl_users`.`updated_at` = '2025-08-15 06:28:26.325839' WHERE `ppl_users`.`id` = 2174 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/membership.rb:75:in 'block in <class:Membership>'
# >>   TRANSACTION (0.5ms)  COMMIT /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/updater.rb:46:in 'block in Ppl::Updater#update_raw'
# >>   Ppl::Mentor Load (0.2ms)  SELECT `ppl_mentors`.* FROM `ppl_mentors` WHERE `ppl_mentors`.`name` = 'X' /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/user_search.rb:29:in 'Ppl::UserSearch#call'
# >>   Ppl::User Load (0.5ms)  SELECT `ppl_users`.* FROM `ppl_users` INNER JOIN `ppl_mentors` ON `ppl_mentors`.`id` = `ppl_users`.`mentor_id` WHERE ( (LOWER(ppl_users.name) LIKE '%a%')) AND `ppl_mentors`.`name` = 'X' ORDER BY promotion_season_number IS NULL, `ppl_users`.`promotion_season_number` ASC, `ppl_users`.`promotion_win` DESC, `ppl_users`.`runner_up_count` DESC, `ppl_users`.`age_min` ASC, `ppl_users`.`memberships_count` ASC /*application='ShogiWeb'*/
# >>   Ppl::Mentor Load (0.2ms)  SELECT `ppl_mentors`.* FROM `ppl_mentors` WHERE `ppl_mentors`.`id` = 920 /*application='ShogiWeb'*/
# >>   Ppl::Membership Load (0.3ms)  SELECT `ppl_memberships`.* FROM `ppl_memberships` WHERE `ppl_memberships`.`user_id` = 2174 /*application='ShogiWeb'*/
# >>   Ppl::LeagueSeason Load (0.3ms)  SELECT `ppl_league_seasons`.* FROM `ppl_league_seasons` WHERE `ppl_league_seasons`.`id` = 543 /*application='ShogiWeb'*/
# >>   Ppl::Result Load (0.2ms)  SELECT `ppl_results`.* FROM `ppl_results` WHERE `ppl_results`.`id` = 4 ORDER BY `ppl_results`.`position` ASC /*application='ShogiWeb'*/
