require "./setup"
user = Swars::User["SugarHuuko"]
mate_stat = user.stat.mate_stat
s { mate_stat.positive_count } # => nil
s { mate_stat.max            } # => nil
s { mate_stat.to_chart   } # => nil
_   { mate_stat.positive_count } # => "0.00 ms"
_   { mate_stat.max            } # => "0.00 ms"
_   { mate_stat.to_chart   } # => "0.00 ms"
# >>   Swars::Membership Ids (39.4ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 17413 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50
# >>   ↳ app/models/swars/stat/base_scope_methods.rb:31:in `scope_ids'
# >>   Swars::Membership Count (0.7ms)  SELECT COUNT(*) FROM `swars_memberships` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `swars_finals` ON `swars_finals`.`id` = `swars_battles`.`final_id` WHERE `swars_memberships`.`id` IN (98271894, 98271896, 98271899, 98271900, 98271902, 98271905, 98271907, 98271909, 98271911, 98271913, 98303204, 98212763, 98212766, 98212768, 98212769, 98212771, 98212774, 98208928, 98212775, 98212778, 98263994, 98263995, 98263998, 98264000, 98264001, 98264003, 98264005, 98264007, 98196869, 98196871, 98196872, 98196874, 98196876, 98196878, 98196881, 98196885, 98196899, 98196901, 98196903, 98196909, 98196911, 98196913, 98196915, 98191817, 97909143, 97909144, 97904863, 97904485, 97904487, 97904490) AND `judges`.`key` = 'win' AND `swars_memberships`.`think_last` >= 30 AND `swars_finals`.`key` = 'CHECKMATE'
# >>   ↳ app/models/swars/stat/mate_stat.rb:47:in `count'
