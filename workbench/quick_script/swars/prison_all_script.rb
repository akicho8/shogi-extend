require "./setup"
sql
_ { QuickScript::Swars::PrisonAllScript.new.call } # => "99.61 ms"
# >>   Swars::User Load (25.0ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`ban_at` IS NOT NULL ORDER BY `swars_users`.`id` ASC LIMIT 1000
# >>   ↳ app/models/quick_script/swars/prison_all_script.rb:9:in `call'
# >>   Swars::User Load (11.0ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`ban_at` IS NOT NULL AND `swars_users`.`id` > 322275 ORDER BY `swars_users`.`id` ASC LIMIT 1000
# >>   ↳ app/models/quick_script/swars/prison_all_script.rb:9:in `call'
# >>   Swars::User Load (6.0ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`ban_at` IS NOT NULL AND `swars_users`.`id` > 543680 ORDER BY `swars_users`.`id` ASC LIMIT 1000
# >>   ↳ app/models/quick_script/swars/prison_all_script.rb:9:in `call'
# >>   Swars::User Load (2.9ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`ban_at` IS NOT NULL AND `swars_users`.`id` > 782365 ORDER BY `swars_users`.`id` ASC LIMIT 1000
# >>   ↳ app/models/quick_script/swars/prison_all_script.rb:9:in `call'
