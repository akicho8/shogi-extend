require "./setup"
_ { Swars::User["SugarHuuko"].stat.waiting_to_leave_stat.count } # => "218.52 ms"
s { Swars::User["SugarHuuko"].stat.waiting_to_leave_stat.count } # => 0
# >>   Swars::User Load (0.2ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'SugarHuuko' LIMIT 1
# >>   ↳ app/models/swars/user.rb:5:in `[]'
# >>   Swars::Membership Ids (17.3ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 17413 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50
# >>   ↳ app/models/swars/stat/base_scope_methods.rb:35:in `scope_ids'
# >>   Swars::Membership Count (0.7ms)  SELECT COUNT(*) FROM `swars_memberships` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`id` IN (98271894, 98271896, 98271899, 98271900, 98271902, 98271905, 98271907, 98271909, 98271911, 98271913, 98303204, 98212763, 98212766, 98212768, 98212769, 98212771, 98212774, 98208928, 98212775, 98212778, 98263994, 98263995, 98263998, 98264000, 98264001, 98264003, 98264005, 98264007, 98196869, 98196871, 98196872, 98196874, 98196876, 98196878, 98196881, 98196885, 98196899, 98196901, 98196903, 98196909, 98196911, 98196913, 98196915, 98191817, 97909143, 97909144, 97904863, 97904485, 97904487, 97904490) AND `judges`.`key` = 'lose' AND `swars_memberships`.`think_last` IS NOT NULL AND `swars_memberships`.`think_max` != `swars_memberships`.`think_last` AND `swars_memberships`.`think_max` >= 300 AND `swars_battles`.`turn_max` >= 14
# >>   ↳ app/models/swars/stat/waiting_to_leave_stat.rb:18:in `block in count'
