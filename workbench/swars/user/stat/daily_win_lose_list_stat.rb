require "./setup"

# user = Swars::User.create!(key: "dev777")
# battle = Swars::Battle.create! do |e|
#   e.memberships.build(user: user, judge_key: :draw)
# end
# exit

Swars::User["micro77"].stat.daily_win_lose_list_stat.to_chart   # => [{:battled_on=>Mon, 03 Jun 2024, :day_type=>nil, :judge_counts=>{:win=>9, :lose=>8}}, {:battled_on=>Sun, 02 Jun 2024, :day_type=>:danger, :judge_counts=>{:win=>18, :lose=>15}}]
Swars::User["micro77"].stat.daily_win_lose_list_stat.to_chart2  # => [{:battled_on=>Mon, 03 Jun 2024, :day_type=>nil, :judge_counts=>{:win=>9, :lose=>8}}, {:battled_on=>Sun, 02 Jun 2024, :day_type=>:danger, :judge_counts=>{:win=>18, :lose=>15}}]

_ { Swars::User["dev777"].stat.daily_win_lose_list_stat.to_chart  } # => "4.39 ms"
_ { Swars::User["dev777"].stat.daily_win_lose_list_stat.to_chart2 } # => "2.83 ms"

_ { Swars::User["dev777"].stat.daily_win_lose_list_stat.to_chart  } # => "4.27 ms"
_ { Swars::User["dev777"].stat.daily_win_lose_list_stat.to_chart2 } # => "3.29 ms"

_ { Swars::User["dev777"].stat.daily_win_lose_list_stat.to_chart2 } # => "3.20 ms"
_ { Swars::User["dev777"].stat.daily_win_lose_list_stat.to_chart  } # => "4.47 ms"

_ { Swars::User["dev777"].stat.daily_win_lose_list_stat.to_chart2 } # => "2.72 ms"
_ { Swars::User["dev777"].stat.daily_win_lose_list_stat.to_chart  } # => "4.23 ms"

s { Swars::User["SugarHuuko"].stat.daily_win_lose_list_stat.to_chart }        # => [{:battled_on=>Wed, 05 Jun 2024, :day_type=>nil, :judge_counts=>{:win=>4, :lose=>0}}, {:battled_on=>Sat, 01 Jun 2024, :day_type=>:info, :judge_counts=>{:win=>5, :lose=>2}}, {:battled_on=>Fri, 31 May 2024, :day_type=>nil, :judge_counts=>{:win=>26, :lose=>13}}]
s { Swars::User["SugarHuuko"].stat.daily_win_lose_list_stat.to_chart2 }        # => [{:battled_on=>Wed, 05 Jun 2024, :day_type=>nil, :judge_counts=>{:win=>4, :lose=>0}}, {:battled_on=>Sat, 01 Jun 2024, :day_type=>:info, :judge_counts=>{:win=>5, :lose=>2}}, {:battled_on=>Fri, 31 May 2024, :day_type=>nil, :judge_counts=>{:win=>26, :lose=>13}}]
# >>   Swars::User Load (0.2ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'SugarHuuko' LIMIT 1
# >>   ↳ app/models/swars/user.rb:9:in `[]'
# >>   Swars::Membership Ids (68.0ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 17413 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50
# >>   ↳ app/models/swars/user/stat/scope_ext.rb:54:in `scope_ids'
# >>   Judge Load (0.3ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`key` = 'win' ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/concerns/memory_record_bind.rb:77:in `lookup'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`key` = 'lose' ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/concerns/memory_record_bind.rb:77:in `lookup'
# >>   Judge Load (0.1ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`key` = 'draw' ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/concerns/memory_record_bind.rb:77:in `lookup'
# >>   Swars::Membership Load (0.8ms)  SELECT DATE(CONVERT_TZ(battled_at, 'UTC', 'Asia/Tokyo')) AS battled_on, COUNT(judge_id = 1  OR NULL) AS win, COUNT(judge_id = 2 OR NULL) AS lose FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`id` IN (99322337, 99322339, 99322341, 99322343, 99049425, 99030316, 99030318, 99030319, 99030328, 99030332, 99030336, 98973484, 98973487, 98973489, 98973491, 98973493, 98973495, 98972125, 98972127, 98972130, 98972132, 98972134, 98972136, 98971214, 98969678, 98969683, 98969687, 98969691, 98969695, 98969697, 98969700, 98969704, 98969709, 98972152, 98966476, 98973059, 98964728, 98964730, 98964731, 98964733, 98964736, 98963461, 98963319, 98963324, 98962470, 98963326, 98963330, 98963333, 98962119, 98963337) AND `swars_memberships`.`judge_id` != 3 GROUP BY battled_on ORDER BY battled_on DESC
# >>   ↳ app/models/swars/user/stat/daily_win_lose_list_stat.rb:25:in `collect'
# >>   Swars::User Load (0.2ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'SugarHuuko' LIMIT 1
# >>   ↳ app/models/swars/user.rb:9:in `[]'
# >>   Swars::Membership Ids (18.9ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 17413 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50
# >>   ↳ app/models/swars/user/stat/scope_ext.rb:54:in `scope_ids'
# >>   Swars::Membership Load (0.4ms)  SELECT DATE(CONVERT_TZ(battled_at, 'UTC', 'Asia/Tokyo')) AS battled_on, COUNT(judges.key = 'win' OR NULL) AS win, COUNT(judges.key = 'lose' OR NULL) AS lose FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` WHERE `swars_memberships`.`id` IN (99322337, 99322339, 99322341, 99322343, 99049425, 99030316, 99030318, 99030319, 99030328, 99030332, 99030336, 98973484, 98973487, 98973489, 98973491, 98973493, 98973495, 98972125, 98972127, 98972130, 98972132, 98972134, 98972136, 98971214, 98969678, 98969683, 98969687, 98969691, 98969695, 98969697, 98969700, 98969704, 98969709, 98972152, 98966476, 98973059, 98964728, 98964730, 98964731, 98964733, 98964736, 98963461, 98963319, 98963324, 98962470, 98963326, 98963330, 98963333, 98962119, 98963337) AND `judges`.`key` != 'draw' GROUP BY battled_on ORDER BY battled_on DESC
# >>   ↳ app/models/swars/user/stat/daily_win_lose_list_stat.rb:48:in `collect'
