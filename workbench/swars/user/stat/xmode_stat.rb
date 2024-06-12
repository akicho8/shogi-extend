require "./setup"
_ { Swars::User["Ito_Shingo"].stat.xmode_stat.to_chart } # => "179.03 ms"
s { Swars::User["Ito_Shingo"].stat.xmode_stat.to_chart } # => [{:name=>"野良", :value=>0}, {:name=>"友達", :value=>0}, {:name=>"指導", :value=>50}]
Swars::User["Ito_Shingo"].stat.xmode_stat.counts_hash    # => {:指導=>50}
Swars::User["Ito_Shingo"].stat.xmode_stat.versus_pro?    # => false

# >>   Swars::User Load (0.3ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'Ito_Shingo' LIMIT 1
# >>   ↳ app/models/swars/user.rb:9:in `[]'
# >>   Swars::Membership Ids (6.7ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 415166 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50
# >>   ↳ app/models/swars/user/stat/scope_ext.rb:54:in `scope_ids'
# >>   Swars::Membership Count (0.9ms)  SELECT COUNT(*) AS `count_all`, `swars_xmodes`.`key` AS `swars_xmodes_key` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `swars_xmodes` ON `swars_xmodes`.`id` = `swars_battles`.`xmode_id` WHERE `swars_memberships`.`id` IN (95043711, 95043714, 95043716, 95043718, 95043720, 94866092, 95025180, 94859372, 94858647, 94858649, 94858651, 94858653, 94858655, 94858657, 94858659, 94858661, 94858663, 94816190, 94597856, 94597858, 94597863, 94597867, 94597871, 94597873, 94393638, 94393642, 94393644, 94393647, 94313212, 94315183, 94324498, 94325808, 94325811, 94325814, 94325818, 94273897, 94233108, 94273899, 94273901, 94173528, 94173530, 94164461, 94164463, 94164466, 94164469, 94164473, 94164476, 94164481, 94161437, 94164483) GROUP BY `swars_xmodes`.`key`
# >>   ↳ app/models/swars/user/stat/xmode_stat.rb:40:in `block in counts_hash'
