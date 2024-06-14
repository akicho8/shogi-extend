require "./setup"
# _ { Swars::User["SugarHuuko"].stat.gdiff_stat.average          } # => "154.56 ms"
# s { Swars::User["SugarHuuko"].stat.gdiff_stat.average          } # => -0.436e1
# s { Swars::User["SugarHuuko"].stat.gdiff_stat.abs              } # => 0.436e1
# Swars::User.create!.stat.gdiff_stat.average # => nil
# Swars::User.create!.stat.gdiff_stat.abs     # => nil

# s { Swars::User.create!.stat.gdiff_stat.reverse_kiryoku_sagi_count } # => 0
s { Swars::User["Taichan0601"].stat.gdiff_stat.reverse_kiryoku_sagi_count } # => 23

# tp Swars::User::Stat::GdiffStat.report
# >>   Swars::User Load (0.5ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'Taichan0601' LIMIT 1
# >>   ↳ app/models/swars/user.rb:44:in `[]'
# >>   Swars::Membership Ids (3.0ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 464468 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50
# >>   ↳ app/models/swars/user/stat/scope_ext.rb:54:in `scope_ids'
# >>   Swars::Membership Count (2.0ms)  SELECT COUNT(*) FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `swars_xmodes` ON `swars_xmodes`.`id` = `swars_battles`.`xmode_id` WHERE `swars_memberships`.`id` IN (99986603, 99980821, 99304156, 99304158, 98297921, 98297925, 96638251, 96638253, 96638254, 95135883, 95135884, 95135887, 95135889, 93981623, 90925745, 90925747, 90925749, 89453082, 89453084, 89453087, 87763231, 87763232, 87763234, 86622830, 86622851, 86622858, 85660563, 85660571, 85660582, 77572944, 77572946, 77572948, 77572949, 68736445, 68736446, 68736449, 53468018, 49416012, 48874673, 48874674, 48874676, 48874679, 48874680, 48874683, 48874684, 48874686, 48874688, 48874691, 48874692, 48874695) AND `swars_memberships`.`grade_diff` >= 10 AND `swars_xmodes`.`key` = '野良'
# >>   ↳ app/models/swars/user/stat/gdiff_stat.rb:42:in `reverse_kiryoku_sagi_count'
