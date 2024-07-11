require "./setup"
_ { Swars::User["SugarHuuko"].stat.ids_scope.total_judge_counts } # => "195.30 ms"
s { Swars::User["SugarHuuko"].stat.ids_scope.total_judge_counts } # => {:win=>46, :lose=>4}
# >>   Swars::User Load (0.2ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'SugarHuuko' LIMIT 1
# >>   ↳ app/models/swars/user.rb:43:in `[]'
# >>   Swars::Membership Ids (36.3ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 17413 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50
# >>   ↳ app/models/swars/user/stat/scope_ext.rb:30:in `scope_ids'
# >>   Swars::Membership Count (0.5ms)  SELECT COUNT(*) AS `count_all`, `judges`.`key` AS `judges_key` FROM `swars_memberships` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` WHERE `swars_memberships`.`id` IN (100015085, 100015087, 100015089, 100015091, 100009154, 100009157, 100007479, 100007489, 100007493, 100007495, 100007498, 100003389, 100003392, 100003397, 100003411, 100003416, 99994325, 99994327, 99993733, 99993076, 99993078, 99993080, 99993082, 99993084, 99983693, 99679774, 99679777, 99675797, 99613479, 99613482, 99570919, 99570920, 99570923, 99570925, 99570927, 99570929, 99570930, 99570932, 99570935, 99570937, 99562447, 99561483, 99561485, 99387462, 99387464, 99387466, 99387469, 99386230, 99387471, 99387472) GROUP BY `judges`.`key`
# >>   ↳ app/models/swars/user/stat/membership_global_extension.rb:14:in `total_judge_counts'
