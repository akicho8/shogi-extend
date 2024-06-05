require "../setup"
_ { Swars::User["SugarHuuko"].user_stat.all_tag.counts_hash[:"居飛車"] } # => "222.31 ms"
s { Swars::User["SugarHuuko"].user_stat.all_tag.counts_hash[:"居飛車"] } # => 50
s { Swars::User["SugarHuuko"].user_stat.win_tag.counts_hash[:"居飛車"] } # => 35

Swars::User["SugarHuuko"].user_stat.win_tag.counts_hash[:"急戦"]   # => 17
Swars::User["SugarHuuko"].user_stat.win_tag.counts_hash[:"持久戦"] # => 15
Swars::User["SugarHuuko"].user_stat.ids_count                      # => 50
Swars::User["SugarHuuko"].user_stat.win_ratio                      # => 0.7

# >>   Swars::User Load (0.2ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'SugarHuuko' LIMIT 1
# >>   ↳ app/models/swars/user.rb:5:in `[]'
# >>   Swars::Membership Ids (36.4ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 17413 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50
# >>   ↳ app/models/swars/user_stat/base_scope_methods.rb:35:in `scope_ids'
# >>   Swars::Membership Pluck (0.4ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (99322337, 99322339, 99322341, 99322343, 99049425, 99030316, 99030318, 99030319, 99030328, 99030332, 99030336, 98973484, 98973487, 98973489, 98973491, 98973493, 98973495, 98972125, 98972127, 98972130, 98972132, 98972134, 98972136, 98971214, 98969678, 98969683, 98969687, 98969691, 98969695, 98969697, 98969700, 98969704, 98969709, 98972152, 98966476, 98973059, 98964728, 98964730, 98964731, 98964733, 98964736, 98963461, 98963319, 98963324, 98962470, 98963326, 98963330, 98963333, 98962119, 98963337)
# >>   ↳ app/models/swars/user_stat/tag_stat.rb:63:in `block in counts_hash'
# >>   ActsAsTaggableOn::Tag Load (1.7ms)  SELECT tags.*, taggings.tags_count AS count FROM `tags` JOIN (SELECT taggings.tag_id, COUNT(taggings.tag_id) AS tags_count FROM `taggings` WHERE (taggings.taggable_type = 'Swars::Membership') AND (taggings.taggable_id IN ('98962119','98962470','98963319','98963324','98963326','98963330','98963333','98963337','98963461','98964728','98964730','98964731','98964733','98964736','98966476','98969678','98969683','98969687','98969691','98969695','98969697','98969700','98969704','98969709','98971214','98972125','98972127','98972130','98972132','98972134','98972136','98972152','98973059','98973484','98973487','98973489','98973491','98973493','98973495','99030316','99030318','99030319','99030328','99030332','99030336','99049425','99322337','99322339','99322341','99322343')) GROUP BY `taggings`.`tag_id` HAVING (COUNT(taggings.tag_id) > 0)) AS taggings ON taggings.tag_id = tags.id
# >>   ↳ app/models/swars/user_stat/tag_stat.rb:64:in `each_with_object'
# >>   Swars::User Load (0.2ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'SugarHuuko' LIMIT 1
# >>   ↳ app/models/swars/user.rb:5:in `[]'
# >>   Swars::Membership Ids (30.2ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 17413 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50
# >>   ↳ app/models/swars/user_stat/base_scope_methods.rb:35:in `scope_ids'
# >>   Swars::Membership Pluck (0.4ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` WHERE `swars_memberships`.`id` IN (99322337, 99322339, 99322341, 99322343, 99049425, 99030316, 99030318, 99030319, 99030328, 99030332, 99030336, 98973484, 98973487, 98973489, 98973491, 98973493, 98973495, 98972125, 98972127, 98972130, 98972132, 98972134, 98972136, 98971214, 98969678, 98969683, 98969687, 98969691, 98969695, 98969697, 98969700, 98969704, 98969709, 98972152, 98966476, 98973059, 98964728, 98964730, 98964731, 98964733, 98964736, 98963461, 98963319, 98963324, 98962470, 98963326, 98963330, 98963333, 98962119, 98963337) AND `judges`.`key` = 'win'
# >>   ↳ app/models/swars/user_stat/tag_stat.rb:63:in `block in counts_hash'
# >>   ActsAsTaggableOn::Tag Load (1.3ms)  SELECT tags.*, taggings.tags_count AS count FROM `tags` JOIN (SELECT taggings.tag_id, COUNT(taggings.tag_id) AS tags_count FROM `taggings` WHERE (taggings.taggable_type = 'Swars::Membership') AND (taggings.taggable_id IN ('98962119','98962470','98963319','98963324','98963326','98963330','98963333','98963337','98963461','98964728','98964730','98964733','98969678','98969687','98969691','98969697','98969700','98969704','98972125','98972130','98972132','98972136','98972152','98973059','98973489','98973495','99030319','99030328','99030332','99030336','99049425','99322337','99322339','99322341','99322343')) GROUP BY `taggings`.`tag_id` HAVING (COUNT(taggings.tag_id) > 0)) AS taggings ON taggings.tag_id = tags.id
# >>   ↳ app/models/swars/user_stat/tag_stat.rb:64:in `each_with_object'
