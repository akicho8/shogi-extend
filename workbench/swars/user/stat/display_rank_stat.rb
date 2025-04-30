require "./setup"
_ { Swars::User["bsplive"].stat(sample_max: 2).display_rank_stat.display_ranks } # => "155.18 ms"
s { Swars::User["bsplive"].stat(sample_max: 2).display_rank_stat.display_ranks } # => [{key: :display_rank_ten_min, short_name: "10分", search_params: {"開始モード" => "通常", "持ち時間" => "10分"}, grade_name: nil}, {key: :display_rank_three_min, short_name: "3分", search_params: {"開始モード" => "通常", "持ち時間" => "3分"}, grade_name: "八段"}, {key: :display_rank_ten_sec, short_name: "10秒", search_params: {"開始モード" => "通常", "持ち時間" => "10秒"}, grade_name: "七段"}, {key: :display_rank_sprint, short_name: "ス", search_params: {"開始モード" => "スプリント"}, grade_name: nil}]

tp Swars::User["bsplive"].stat(sample_max: 1).display_rank_stat.display_ranks
tp Swars::User["bsplive"].stat(sample_max: 1).display_rank_stat.display_ranks_hash

# >>   Swars::User Load (0.4ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'bsplive' LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/swars/user.rb:45:in 'Swars::User.[]'
# >>   Swars::Membership Ids (6.9ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 22122 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 2 /*application='ShogiWeb'*/
# >>   ↳ app/models/swars/user/stat/scope_ext.rb:31:in 'Swars::User::Stat::ScopeExt#scope_ids'
# >>   Swars::Membership Load (0.8ms)  SELECT swars_rules.key AS rule_key, MIN(swars_grades.priority) AS min_priority FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `swars_imodes` ON `swars_imodes`.`id` = `swars_battles`.`imode_id` INNER JOIN `swars_rules` ON `swars_rules`.`id` = `swars_battles`.`rule_id` INNER JOIN `swars_grades` ON `swars_grades`.`id` = `swars_memberships`.`grade_id` WHERE `swars_memberships`.`id` IN (118568280, 118568282) AND `swars_imodes`.`key` = 'normal' GROUP BY `rule_key` /*application='ShogiWeb'*/
# >>   ↳ app/models/swars/user/stat/display_rank_stat.rb:70:in 'block (2 levels) in Swars::User::Stat::DisplayRankStat#normal_grades_hash'
# >>   Swars::Membership Load (0.6ms)  SELECT MIN(swars_grades.priority) AS min_priority FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `swars_imodes` ON `swars_imodes`.`id` = `swars_battles`.`imode_id` INNER JOIN `swars_grades` ON `swars_grades`.`id` = `swars_memberships`.`grade_id` WHERE `swars_memberships`.`id` IN (118568280, 118568282) AND `swars_imodes`.`key` = 'sprint' LIMIT 1 /*application='ShogiWeb'*/
# >>   ↳ app/models/swars/user/stat/display_rank_stat.rb:49:in 'block in Swars::User::Stat::DisplayRankStat#display_rank_sprint'
# >> |------------------------+------------+------------------------------------------------+------------|
# >> | key                    | short_name | search_params                                  | grade_name |
# >> |------------------------+------------+------------------------------------------------+------------|
# >> | display_rank_ten_min   | 10分       | {"開始モード" => "通常", "持ち時間" => "10分"} |            |
# >> | display_rank_three_min | 3分        | {"開始モード" => "通常", "持ち時間" => "3分"}  | 八段       |
# >> | display_rank_ten_sec   | 10秒       | {"開始モード" => "通常", "持ち時間" => "10秒"} |            |
# >> | display_rank_sprint    | ス         | {"開始モード" => "スプリント"}                 |            |
# >> |------------------------+------------+------------------------------------------------+------------|
# >> |------------+------|
# >> |       10分 |      |
# >> |        3分 | 八段 |
# >> |       10秒 |      |
# >> | スプリント |      |
# >> |------------+------|
