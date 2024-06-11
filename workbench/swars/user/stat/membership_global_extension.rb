require "./setup"
_ { Swars::User["SugarHuuko"].stat.ids_scope.total_judge_counts } # => "264.07 ms"
s { Swars::User["SugarHuuko"].stat.ids_scope.total_judge_counts } # => {:win=>35, :lose=>15}
# >>   Swars::User Load (0.2ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'SugarHuuko' LIMIT 1
# >>   ↳ app/models/swars/user.rb:9:in `[]'
# >>   Swars::Membership Ids (55.8ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 17413 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50
# >>   ↳ app/models/swars/user/stat/scope_ext.rb:54:in `scope_ids'
# >>   Swars::Membership Count (0.7ms)  SELECT COUNT(*) AS `count_all`, `judges`.`key` AS `judges_key` FROM `swars_memberships` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` WHERE `swars_memberships`.`id` IN (99322337, 99322339, 99322341, 99322343, 99049425, 99030316, 99030318, 99030319, 99030328, 99030332, 99030336, 98973484, 98973487, 98973489, 98973491, 98973493, 98973495, 98972125, 98972127, 98972130, 98972132, 98972134, 98972136, 98971214, 98969678, 98969683, 98969687, 98969691, 98969695, 98969697, 98969700, 98969704, 98969709, 98972152, 98966476, 98973059, 98964728, 98964730, 98964731, 98964733, 98964736, 98963461, 98963319, 98963324, 98962470, 98963326, 98963330, 98963333, 98962119, 98963337) GROUP BY `judges`.`key`
# >>   ↳ app/models/swars/user/stat/membership_global_extension.rb:14:in `total_judge_counts'
