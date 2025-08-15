require "#{__dir__}/setup"
Ppl.setup_for_workbench
Ppl::Updater.update_raw(5, { mentor: "X", name: "alice", })
Ppl::Updater.update_raw(6, { mentor: "Y", name: "bob",   })
Ppl::Updater.update_raw(7, { mentor: "Z", name: "carol", })
sql
Ppl::User.search(name: "a").collect(&:name)          # => ["alice", "bob", "carol"]
Ppl::User.search(season_number: "6").collect(&:name) # => ["bob"]
Ppl::User.search(mentor_name: "X").collect(&:name)       # => ["alice"]
Ppl::User.search(query: "a").collect(&:name)             # => ["alice", "carol"]
# >>   Ppl::User Load (0.4ms)  SELECT `ppl_users`.* FROM `ppl_users` WHERE `ppl_users`.`name` = 'a' /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/user_search.rb:23:in 'Ppl::UserSearch#call'
# >>   Ppl::User Load (0.4ms)  SELECT `ppl_users`.* FROM `ppl_users` ORDER BY promotion_season_number IS NULL, `ppl_users`.`promotion_season_number` ASC, `ppl_users`.`promotion_win` DESC, `ppl_users`.`runner_up_count` DESC, `ppl_users`.`age_min` ASC, `ppl_users`.`memberships_count` ASC /*application='ShogiWeb'*/
# >>   Ppl::Mentor Load (0.3ms)  SELECT `ppl_mentors`.* FROM `ppl_mentors` WHERE `ppl_mentors`.`id` IN (171, 172, 173) /*application='ShogiWeb'*/
# >>   Ppl::Membership Load (0.4ms)  SELECT `ppl_memberships`.* FROM `ppl_memberships` WHERE `ppl_memberships`.`user_id` IN (324, 325, 326) /*application='ShogiWeb'*/
# >>   Ppl::LeagueSeason Load (0.3ms)  SELECT `ppl_league_seasons`.* FROM `ppl_league_seasons` WHERE `ppl_league_seasons`.`id` IN (159, 160, 161) /*application='ShogiWeb'*/
# >>   Ppl::Result Load (0.3ms)  SELECT `ppl_results`.* FROM `ppl_results` WHERE `ppl_results`.`id` = 4 ORDER BY `ppl_results`.`position` ASC /*application='ShogiWeb'*/
# >>   Ppl::LeagueSeason Load (0.3ms)  SELECT `ppl_league_seasons`.* FROM `ppl_league_seasons` WHERE `ppl_league_seasons`.`season_number` = 6 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/user_search.rb:34:in 'Ppl::UserSearch#call'
# >>   Ppl::User Pluck (0.4ms)  SELECT `ppl_users`.`id` FROM `ppl_users` INNER JOIN `ppl_memberships` ON `ppl_users`.`id` = `ppl_memberships`.`user_id` WHERE `ppl_memberships`.`league_season_id` = 160 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/user_search.rb:35:in 'block in Ppl::UserSearch#call'
# >>   Ppl::User Load (0.3ms)  SELECT `ppl_users`.* FROM `ppl_users` WHERE `ppl_users`.`id` = 325 ORDER BY promotion_season_number IS NULL, `ppl_users`.`promotion_season_number` ASC, `ppl_users`.`promotion_win` DESC, `ppl_users`.`runner_up_count` DESC, `ppl_users`.`age_min` ASC, `ppl_users`.`memberships_count` ASC /*application='ShogiWeb'*/
# >>   Ppl::Mentor Load (0.3ms)  SELECT `ppl_mentors`.* FROM `ppl_mentors` WHERE `ppl_mentors`.`id` = 172 /*application='ShogiWeb'*/
# >>   Ppl::Membership Load (0.3ms)  SELECT `ppl_memberships`.* FROM `ppl_memberships` WHERE `ppl_memberships`.`user_id` = 325 /*application='ShogiWeb'*/
# >>   Ppl::LeagueSeason Load (0.2ms)  SELECT `ppl_league_seasons`.* FROM `ppl_league_seasons` WHERE `ppl_league_seasons`.`id` = 160 /*application='ShogiWeb'*/
# >>   Ppl::Result Load (0.2ms)  SELECT `ppl_results`.* FROM `ppl_results` WHERE `ppl_results`.`id` = 4 ORDER BY `ppl_results`.`position` ASC /*application='ShogiWeb'*/
# >>   Ppl::Mentor Load (0.2ms)  SELECT `ppl_mentors`.* FROM `ppl_mentors` WHERE `ppl_mentors`.`name` = 'X' /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/user_search.rb:29:in 'Ppl::UserSearch#call'
# >>   Ppl::User Load (0.4ms)  SELECT `ppl_users`.* FROM `ppl_users` INNER JOIN `ppl_mentors` ON `ppl_mentors`.`id` = `ppl_users`.`mentor_id` WHERE `ppl_mentors`.`name` = 'X' ORDER BY promotion_season_number IS NULL, `ppl_users`.`promotion_season_number` ASC, `ppl_users`.`promotion_win` DESC, `ppl_users`.`runner_up_count` DESC, `ppl_users`.`age_min` ASC, `ppl_users`.`memberships_count` ASC /*application='ShogiWeb'*/
# >>   Ppl::Mentor Load (0.2ms)  SELECT `ppl_mentors`.* FROM `ppl_mentors` WHERE `ppl_mentors`.`id` = 171 /*application='ShogiWeb'*/
# >>   Ppl::Membership Load (0.3ms)  SELECT `ppl_memberships`.* FROM `ppl_memberships` WHERE `ppl_memberships`.`user_id` = 324 /*application='ShogiWeb'*/
# >>   Ppl::LeagueSeason Load (0.2ms)  SELECT `ppl_league_seasons`.* FROM `ppl_league_seasons` WHERE `ppl_league_seasons`.`id` = 159 /*application='ShogiWeb'*/
# >>   Ppl::Result Load (0.2ms)  SELECT `ppl_results`.* FROM `ppl_results` WHERE `ppl_results`.`id` = 4 ORDER BY `ppl_results`.`position` ASC /*application='ShogiWeb'*/
# >>   Ppl::User Load (0.4ms)  SELECT `ppl_users`.* FROM `ppl_users` WHERE ( (LOWER(name) LIKE '%a%')) ORDER BY promotion_season_number IS NULL, `ppl_users`.`promotion_season_number` ASC, `ppl_users`.`promotion_win` DESC, `ppl_users`.`runner_up_count` DESC, `ppl_users`.`age_min` ASC, `ppl_users`.`memberships_count` ASC /*application='ShogiWeb'*/
# >>   Ppl::Mentor Load (0.3ms)  SELECT `ppl_mentors`.* FROM `ppl_mentors` WHERE `ppl_mentors`.`id` IN (171, 173) /*application='ShogiWeb'*/
# >>   Ppl::Membership Load (0.3ms)  SELECT `ppl_memberships`.* FROM `ppl_memberships` WHERE `ppl_memberships`.`user_id` IN (324, 326) /*application='ShogiWeb'*/
# >>   Ppl::LeagueSeason Load (0.2ms)  SELECT `ppl_league_seasons`.* FROM `ppl_league_seasons` WHERE `ppl_league_seasons`.`id` IN (159, 161) /*application='ShogiWeb'*/
# >>   Ppl::Result Load (0.3ms)  SELECT `ppl_results`.* FROM `ppl_results` WHERE `ppl_results`.`id` = 4 ORDER BY `ppl_results`.`position` ASC /*application='ShogiWeb'*/
