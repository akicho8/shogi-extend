require "./setup"
_ { Swars::User["Dounannamari"].stat.skill_adjust_stat.count }        # => "98.87 ms"
s { Swars::User["Dounannamari"].stat.skill_adjust_stat.count }        # => 0
# >>   Swars::User Load (0.3ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'Dounannamari' LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/swars/user.rb:44:in 'Swars::User.[]'
# >>   Swars::Membership Ids (0.4ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 746616 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50 /*application='ShogiWeb'*/
# >>   ↳ app/models/swars/user/stat/scope_ext.rb:31:in 'Swars::User::Stat::ScopeExt#scope_ids'
# >>   Swars::Membership Count (0.7ms)  SELECT COUNT(*) FROM `swars_memberships` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `swars_imodes` ON `swars_imodes`.`id` = `swars_battles`.`imode_id` INNER JOIN `swars_finals` ON `swars_finals`.`id` = `swars_battles`.`final_id` WHERE `swars_memberships`.`id` IN (97369169, 95644125, 72726804) AND `judges`.`key` = 'lose' AND `swars_imodes`.`key` = 'normal' AND (`swars_finals`.`key` = 'TORYO' OR `swars_finals`.`key` = 'CHECKMATE') AND `swars_battles`.`turn_max` < 14 /*application='ShogiWeb'*/
# >>   ↳ app/models/swars/user/stat/skill_adjust_stat.rb:27:in 'block in Swars::User::Stat::SkillAdjustStat#count'
