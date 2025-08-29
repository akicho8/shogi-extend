require "#{__dir__}/setup"
_ { QuickScript::General::PreProfessionalLeaguePlayerScript.new(user_name: "三田敏弘").call } # => "75.52 ms"
s { QuickScript::General::PreProfessionalLeaguePlayerScript.new(user_name: "三田敏弘").call }

# >>   Ppl::User Load (0.4ms)  SELECT `ppl_users`.* FROM `ppl_users` WHERE `ppl_users`.`name` = '三田敏弘' LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/ppl/user.rb:44:in 'Ppl::User.[]'
# >>   SQL (0.9ms)  SELECT `ppl_memberships`.`id` AS t0_r0, `ppl_memberships`.`season_id` AS t0_r1, `ppl_memberships`.`user_id` AS t0_r2, `ppl_memberships`.`result_id` AS t0_r3, `ppl_memberships`.`age` AS t0_r4, `ppl_memberships`.`win` AS t0_r5, `ppl_memberships`.`lose` AS t0_r6, `ppl_memberships`.`ox` AS t0_r7, `ppl_memberships`.`created_at` AS t0_r8, `ppl_memberships`.`updated_at` AS t0_r9, `ppl_seasons`.`id` AS t1_r0, `ppl_seasons`.`key` AS t1_r1, `ppl_seasons`.`position` AS t1_r2, `ppl_seasons`.`created_at` AS t1_r3, `ppl_seasons`.`updated_at` AS t1_r4, `ppl_results`.`id` AS t2_r0, `ppl_results`.`key` AS t2_r1, `ppl_results`.`position` AS t2_r2, `ppl_results`.`created_at` AS t2_r3, `ppl_results`.`updated_at` AS t2_r4 FROM `ppl_memberships` LEFT OUTER JOIN `ppl_seasons` ON `ppl_seasons`.`id` = `ppl_memberships`.`season_id` LEFT OUTER JOIN `ppl_results` ON `ppl_results`.`id` = `ppl_memberships`.`result_id` WHERE `ppl_memberships`.`user_id` = 358 ORDER BY `ppl_seasons`.`position` DESC /*application='ShogiWeb'*/
# >>   ↳ app/models/quick_script/general/pre_professional_league_player_script.rb:145:in 'Enumerable#collect'
