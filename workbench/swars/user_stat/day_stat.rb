require "../setup"
_ { Swars::User["SugarHuuko"].user_stat.day_stat.to_chart_slow }   # => "297.36 ms"

_ { Swars::User["SugarHuuko"].user_stat.day_stat.to_chart }        # => "47.28 ms"
s { Swars::User["SugarHuuko"].user_stat.day_stat.to_chart }        # => [{:battled_on=>Tue, 21 May 2024, :day_type=>nil, :judge_counts=>{:win=>7, :lose=>3}}, {:battled_on=>Mon, 20 May 2024, :day_type=>nil, :judge_counts=>{:win=>25, :lose=>4}}, {:battled_on=>Sun, 19 May 2024, :day_type=>:danger, :judge_counts=>{:win=>2, :lose=>0}}, {:battled_on=>Wed, 15 May 2024, :day_type=>nil, :judge_counts=>{:win=>5, :lose=>1}}]
_ { Swars::User["SugarHuuko"].user_stat.day_stat.to_chart_slow }   # => "80.97 ms"
s { Swars::User["SugarHuuko"].user_stat.day_stat.to_chart_slow }   # => [{:battled_on=>Tue, 21 May 2024, :day_type=>nil, :judge_counts=>{"win"=>7, "lose"=>3}}, {:battled_on=>Mon, 20 May 2024, :day_type=>nil, :judge_counts=>{"win"=>25, "lose"=>4}}, {:battled_on=>Sun, 19 May 2024, :day_type=>:danger, :judge_counts=>{"win"=>2, "lose"=>0}}, {:battled_on=>Wed, 15 May 2024, :day_type=>nil, :judge_counts=>{"win"=>5, "lose"=>1}}]
# >>   Swars::User Load (0.2ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'SugarHuuko' LIMIT 1
# >>   ↳ app/models/swars/user.rb:5:in `[]'
# >>   Swars::Membership Ids (17.3ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 17413 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50
# >>   ↳ app/models/swars/user_stat/base_scope_methods.rb:31:in `scope_ids'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`key` = 'win' ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/concerns/memory_record_bind.rb:77:in `lookup'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`key` = 'lose' ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/concerns/memory_record_bind.rb:77:in `lookup'
# >>   Swars::Membership Load (0.4ms)  SELECT DATE(CONVERT_TZ(battled_at, 'UTC', 'Asia/Tokyo')) AS battled_on, COUNT(judge_id = 1  OR NULL) AS win, COUNT(judge_id = 2 OR NULL) AS lose FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`id` IN (98271894, 98271896, 98271899, 98271900, 98271902, 98271905, 98271907, 98271909, 98271911, 98271913, 98303204, 98212763, 98212766, 98212768, 98212769, 98212771, 98212774, 98208928, 98212775, 98212778, 98263994, 98263995, 98263998, 98264000, 98264001, 98264003, 98264005, 98264007, 98196869, 98196871, 98196872, 98196874, 98196876, 98196878, 98196881, 98196885, 98196899, 98196901, 98196903, 98196909, 98196911, 98196913, 98196915, 98191817, 97909143, 97909144, 97904863, 97904485, 97904487, 97904490) GROUP BY battled_on ORDER BY battled_on DESC
# >>   ↳ app/models/swars/user_stat/day_stat.rb:24:in `collect'
# >>   Swars::User Load (0.2ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'SugarHuuko' LIMIT 1
# >>   ↳ app/models/swars/user.rb:5:in `[]'
# >>   Swars::Membership Ids (18.9ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 17413 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50
# >>   ↳ app/models/swars/user_stat/base_scope_methods.rb:31:in `scope_ids'
# >>   Swars::Membership Load (0.5ms)  SELECT `swars_memberships`.* FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`id` IN (98271894, 98271896, 98271899, 98271900, 98271902, 98271905, 98271907, 98271909, 98271911, 98271913, 98303204, 98212763, 98212766, 98212768, 98212769, 98212771, 98212774, 98208928, 98212775, 98212778, 98263994, 98263995, 98263998, 98264000, 98264001, 98264003, 98264005, 98264007, 98196869, 98196871, 98196872, 98196874, 98196876, 98196878, 98196881, 98196885, 98196899, 98196901, 98196903, 98196909, 98196911, 98196913, 98196915, 98191817, 97909143, 97909144, 97904863, 97904485, 97904487, 97904490) ORDER BY `swars_battles`.`battled_at` DESC
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `group_by'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49247810 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49247811 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49247812 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49247813 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49247814 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49247815 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49247816 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49247817 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49247818 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49247819 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49263477 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49218211 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49218212 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49218213 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49218214 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49218215 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49218216 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49216292 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49218217 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49218218 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49243855 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49243856 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49243857 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49243858 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49243859 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49243860 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49243861 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49243862 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49210254 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49210255 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49210256 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49210257 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49210258 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49210259 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49210260 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49210262 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49210269 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49210270 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.1ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49210271 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.1ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49210274 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.1ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49210275 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.1ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49210276 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.1ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49210277 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.1ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49207726 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.1ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49066223 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49066224 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49064081 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49063892 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49063893 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Swars::Battle Load (0.2ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 49063894 LIMIT 1
# >>   ↳ app/models/swars/user_stat/day_stat.rb:40:in `block in to_chart_slow'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 2 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 2 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 2 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 3 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 2 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 2 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 3 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.1ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.4ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 3 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 2 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.1ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 2 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.1ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.1ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.1ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.3ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.1ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.1ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 2 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
