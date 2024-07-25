require "./setup"
sql
QuickScript::Swars::BattleHistoryScript.new({user_key: "bsplive", google_sheet: "true"}, {_method: "post", current_user: User.admin}).call
# >>   User Load (0.5ms)  SELECT `users`.* FROM `users` WHERE `users`.`key` = 'admin' LIMIT 1
# >>   ↳ app/models/user/staff_methods.rb:18:in `staff_create!'
# >>   Swars::User Load (0.5ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'bsplive' LIMIT 1
# >>   ↳ app/models/swars/user.rb:43:in `[]'
# >>   Swars::Grade Load (0.2ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` = 2 ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/swars/user/grade_methods.rb:28:in `name_with_grade'
# >>   Swars::Membership Load (36.1ms)  SELECT `swars_memberships`.* FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 22122 ORDER BY `battled_at` DESC LIMIT 10
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:78:in `block in rows'
# >>   Swars::Battle Load (1.0ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` IN (50043454, 50043455, 50043456, 50037333, 50037334, 50037335, 50030996, 50030997, 50030819, 50030437)
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:78:in `block in rows'
# >>   Swars::Membership Load (1.8ms)  SELECT `swars_memberships`.* FROM `swars_memberships` WHERE `swars_memberships`.`battle_id` IN (50030437, 50030819, 50030996, 50030997, 50037333, 50037334, 50037335, 50043454, 50043455, 50043456) ORDER BY `swars_memberships`.`position` ASC
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:78:in `block in rows'
# >>   Swars::Xmode Load (0.3ms)  SELECT `swars_xmodes`.* FROM `swars_xmodes` WHERE `swars_xmodes`.`id` = 1 ORDER BY `swars_xmodes`.`position` ASC
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:78:in `block in rows'
# >>   Swars::Final Load (0.5ms)  SELECT `swars_finals`.* FROM `swars_finals` WHERE `swars_finals`.`id` IN (3, 1, 2) ORDER BY `swars_finals`.`position` ASC
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:78:in `block in rows'
# >>   ActsAsTaggableOn::Tagging Load (1.8ms)  SELECT `taggings`.* FROM `taggings` WHERE `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` IN (99853149, 99853151, 99853152, 99841040, 99841042, 99841044, 99828457, 99828458, 99828106, 99827349)
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:78:in `block in rows'
# >>   ActsAsTaggableOn::Tag Load (0.5ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` IN (1433, 200929, 201072, 146, 116094, 122778, 95187, 276, 459, 201387, 97166, 201036, 120282, 15, 38, 116090, 122779, 122776, 122784, 201279, 200937, 201273, 122777, 201349, 201276, 119951)
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:78:in `block in rows'
# >>   Swars::User Load (0.5ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`id` IN (469397, 62156, 935636, 75970, 632622, 12129, 593719, 195384, 35025, 954399)
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:78:in `block in rows'
# >>   Location Load (0.4ms)  SELECT `locations`.* FROM `locations` WHERE `locations`.`id` IN (2, 1) ORDER BY `locations`.`position` ASC
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:78:in `block in rows'
# >>   Swars::Style Load (0.4ms)  SELECT `swars_styles`.* FROM `swars_styles` WHERE `swars_styles`.`id` IN (1, 2, 3) ORDER BY `swars_styles`.`position` ASC
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:78:in `block in rows'
# >>   Swars::Grade Load (0.2ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` = 2 ORDER BY `swars_grades`.`priority` ASC
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:78:in `block in rows'
# >>   Swars::Membership Load (0.4ms)  SELECT `swars_memberships`.* FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (99853148, 99853150, 99853153, 99841041, 99841043, 99841045, 99828456, 99828459, 99828105, 99827351)
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:78:in `block in rows'
# >>   ActsAsTaggableOn::Tagging Load (1.0ms)  SELECT `taggings`.* FROM `taggings` WHERE `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` IN (99827351, 99828105, 99828456, 99828459, 99841041, 99841043, 99841045, 99853148, 99853150, 99853153)
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:78:in `block in rows'
# >>   ActsAsTaggableOn::Tag Load (0.6ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` IN (239, 134, 201073, 122776, 113534, 642, 643, 201339, 122778, 95187, 131, 64, 38, 201036, 201038, 316, 116089, 15, 116090, 355, 37, 116302, 122779, 122784, 201279, 200937, 201273, 122777, 201349, 201276, 119950)
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:78:in `block in rows'
# >>   Swars::Grade Load (0.3ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` = 2 ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:91:in `block in record_to_row'
# >>   Judge Load (0.4ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 2 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:92:in `block in record_to_row'
# >>   Swars::Style Load (0.4ms)  SELECT `swars_styles`.* FROM `swars_styles` WHERE `swars_styles`.`id` = 1 ORDER BY `swars_styles`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:101:in `block in record_to_row'
# >>   Swars::Rule Load (0.4ms)  SELECT `swars_rules`.* FROM `swars_rules` WHERE `swars_rules`.`id` = 2 ORDER BY `swars_rules`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:102:in `block in record_to_row'
# >>   Preset Load (0.4ms)  SELECT `presets`.* FROM `presets` WHERE `presets`.`id` = 1 ORDER BY `presets`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:108:in `public_send'
# >> [self]   ActsAsTaggableOn::Tag Load (2.1ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99853149 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:108:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (1.0ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99853149 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:109:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.9ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99853149 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:110:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.8ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99853149 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:111:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99853148 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:115:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99853148 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:116:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.5ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99853148 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:117:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.4ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99853148 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:118:in `block (2 levels) in record_to_row'
# >>   Swars::Grade Load (0.3ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` = 5 ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:91:in `block in record_to_row'
# >>   Judge Load (0.3ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:92:in `block in record_to_row'
# >>   Swars::Style Load (0.2ms)  SELECT `swars_styles`.* FROM `swars_styles` WHERE `swars_styles`.`id` = 1 ORDER BY `swars_styles`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:101:in `block in record_to_row'
# >>   Swars::Rule Load (0.2ms)  SELECT `swars_rules`.* FROM `swars_rules` WHERE `swars_rules`.`id` = 2 ORDER BY `swars_rules`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:102:in `block in record_to_row'
# >>   Preset Load (0.2ms)  SELECT `presets`.* FROM `presets` WHERE `presets`.`id` = 1 ORDER BY `presets`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:108:in `public_send'
# >> [self]   ActsAsTaggableOn::Tag Load (0.9ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99853151 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:108:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99853151 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:109:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99853151 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:110:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99853151 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:111:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99853150 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:115:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99853150 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:116:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99853150 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:117:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99853150 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:118:in `block (2 levels) in record_to_row'
# >>   Swars::Grade Load (0.3ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` = 5 ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:91:in `block in record_to_row'
# >>   Judge Load (0.3ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:92:in `block in record_to_row'
# >>   Swars::Style Load (0.3ms)  SELECT `swars_styles`.* FROM `swars_styles` WHERE `swars_styles`.`id` = 1 ORDER BY `swars_styles`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:101:in `block in record_to_row'
# >>   Swars::Rule Load (0.2ms)  SELECT `swars_rules`.* FROM `swars_rules` WHERE `swars_rules`.`id` = 2 ORDER BY `swars_rules`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:102:in `block in record_to_row'
# >>   Preset Load (0.2ms)  SELECT `presets`.* FROM `presets` WHERE `presets`.`id` = 1 ORDER BY `presets`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:108:in `public_send'
# >> [self]   ActsAsTaggableOn::Tag Load (0.5ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99853152 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:108:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99853152 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:109:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99853152 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:110:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99853152 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:111:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99853153 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:115:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99853153 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:116:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99853153 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:117:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99853153 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:118:in `block (2 levels) in record_to_row'
# >>   Swars::Grade Load (0.3ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` = 4 ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:91:in `block in record_to_row'
# >>   Judge Load (0.3ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:92:in `block in record_to_row'
# >>   Swars::Style Load (0.3ms)  SELECT `swars_styles`.* FROM `swars_styles` WHERE `swars_styles`.`id` = 2 ORDER BY `swars_styles`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:101:in `block in record_to_row'
# >>   Swars::Rule Load (0.3ms)  SELECT `swars_rules`.* FROM `swars_rules` WHERE `swars_rules`.`id` = 2 ORDER BY `swars_rules`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:102:in `block in record_to_row'
# >>   Preset Load (0.3ms)  SELECT `presets`.* FROM `presets` WHERE `presets`.`id` = 1 ORDER BY `presets`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:108:in `public_send'
# >> [self]   ActsAsTaggableOn::Tag Load (0.6ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99841040 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:108:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.9ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99841040 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:109:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.5ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99841040 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:110:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99841040 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:111:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.6ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99841041 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:115:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.4ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99841041 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:116:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99841041 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:117:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.4ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99841041 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:118:in `block (2 levels) in record_to_row'
# >>   Swars::Grade Load (0.2ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` = 4 ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:91:in `block in record_to_row'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:92:in `block in record_to_row'
# >>   Swars::Style Load (0.2ms)  SELECT `swars_styles`.* FROM `swars_styles` WHERE `swars_styles`.`id` = 2 ORDER BY `swars_styles`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:101:in `block in record_to_row'
# >>   Swars::Rule Load (0.2ms)  SELECT `swars_rules`.* FROM `swars_rules` WHERE `swars_rules`.`id` = 2 ORDER BY `swars_rules`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:102:in `block in record_to_row'
# >>   Preset Load (0.2ms)  SELECT `presets`.* FROM `presets` WHERE `presets`.`id` = 1 ORDER BY `presets`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:108:in `public_send'
# >> [self]   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99841042 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:108:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99841042 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:109:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99841042 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:110:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99841042 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:111:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.6ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99841043 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:115:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99841043 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:116:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.6ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99841043 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:117:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99841043 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:118:in `block (2 levels) in record_to_row'
# >>   Swars::Grade Load (0.2ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` = 3 ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:91:in `block in record_to_row'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:92:in `block in record_to_row'
# >>   Swars::Style Load (0.2ms)  SELECT `swars_styles`.* FROM `swars_styles` WHERE `swars_styles`.`id` = 2 ORDER BY `swars_styles`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:101:in `block in record_to_row'
# >>   Swars::Rule Load (0.2ms)  SELECT `swars_rules`.* FROM `swars_rules` WHERE `swars_rules`.`id` = 2 ORDER BY `swars_rules`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:102:in `block in record_to_row'
# >>   Preset Load (0.2ms)  SELECT `presets`.* FROM `presets` WHERE `presets`.`id` = 1 ORDER BY `presets`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:108:in `public_send'
# >> [self]   ActsAsTaggableOn::Tag Load (0.4ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99841044 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:108:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99841044 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:109:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99841044 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:110:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.6ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99841044 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:111:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.6ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99841045 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:115:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.6ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99841045 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:116:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.6ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99841045 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:117:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99841045 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:118:in `block (2 levels) in record_to_row'
# >>   Swars::Grade Load (0.3ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` = 4 ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:91:in `block in record_to_row'
# >>   Judge Load (0.3ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:92:in `block in record_to_row'
# >>   Swars::Style Load (0.2ms)  SELECT `swars_styles`.* FROM `swars_styles` WHERE `swars_styles`.`id` = 1 ORDER BY `swars_styles`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:101:in `block in record_to_row'
# >>   Swars::Rule Load (0.2ms)  SELECT `swars_rules`.* FROM `swars_rules` WHERE `swars_rules`.`id` = 2 ORDER BY `swars_rules`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:102:in `block in record_to_row'
# >>   Preset Load (0.2ms)  SELECT `presets`.* FROM `presets` WHERE `presets`.`id` = 1 ORDER BY `presets`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:108:in `public_send'
# >> [self]   ActsAsTaggableOn::Tag Load (0.5ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99828457 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:108:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (1.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99828457 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:109:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.6ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99828457 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:110:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.8ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99828457 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:111:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.8ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99828456 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:115:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.6ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99828456 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:116:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.4ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99828456 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:117:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.5ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99828456 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:118:in `block (2 levels) in record_to_row'
# >>   Swars::Grade Load (0.3ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` = 5 ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:91:in `block in record_to_row'
# >>   Judge Load (0.3ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:92:in `block in record_to_row'
# >>   Swars::Style Load (0.2ms)  SELECT `swars_styles`.* FROM `swars_styles` WHERE `swars_styles`.`id` = 1 ORDER BY `swars_styles`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:101:in `block in record_to_row'
# >>   Swars::Rule Load (0.2ms)  SELECT `swars_rules`.* FROM `swars_rules` WHERE `swars_rules`.`id` = 2 ORDER BY `swars_rules`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:102:in `block in record_to_row'
# >>   Preset Load (0.2ms)  SELECT `presets`.* FROM `presets` WHERE `presets`.`id` = 1 ORDER BY `presets`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:108:in `public_send'
# >> [self]   ActsAsTaggableOn::Tag Load (1.2ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99828458 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:108:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.8ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99828458 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:109:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (1.0ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99828458 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:110:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (1.0ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99828458 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:111:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (1.2ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99828459 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:115:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.5ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99828459 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:116:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.4ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99828459 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:117:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.4ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99828459 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:118:in `block (2 levels) in record_to_row'
# >>   Swars::Grade Load (0.2ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` = 4 ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:91:in `block in record_to_row'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:92:in `block in record_to_row'
# >>   Swars::Style Load (0.2ms)  SELECT `swars_styles`.* FROM `swars_styles` WHERE `swars_styles`.`id` = 1 ORDER BY `swars_styles`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:101:in `block in record_to_row'
# >>   Swars::Rule Load (0.2ms)  SELECT `swars_rules`.* FROM `swars_rules` WHERE `swars_rules`.`id` = 2 ORDER BY `swars_rules`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:102:in `block in record_to_row'
# >>   Preset Load (0.3ms)  SELECT `presets`.* FROM `presets` WHERE `presets`.`id` = 1 ORDER BY `presets`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:108:in `public_send'
# >> [self]   ActsAsTaggableOn::Tag Load (0.8ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99828106 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:108:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.8ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99828106 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:109:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99828106 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:110:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.8ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99828106 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:111:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.8ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99828105 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:115:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99828105 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:116:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99828105 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:117:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99828105 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:118:in `block (2 levels) in record_to_row'
# >>   Swars::Grade Load (0.3ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` = 5 ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:91:in `block in record_to_row'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:92:in `block in record_to_row'
# >>   Swars::Style Load (0.2ms)  SELECT `swars_styles`.* FROM `swars_styles` WHERE `swars_styles`.`id` = 1 ORDER BY `swars_styles`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:101:in `block in record_to_row'
# >>   Swars::Rule Load (0.2ms)  SELECT `swars_rules`.* FROM `swars_rules` WHERE `swars_rules`.`id` = 2 ORDER BY `swars_rules`.`position` ASC LIMIT 1
# >>   ↳ app/models/quick_script/swars/battle_history_script.rb:102:in `block in record_to_row'
# >>   Preset Load (0.2ms)  SELECT `presets`.* FROM `presets` WHERE `presets`.`id` = 1 ORDER BY `presets`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:108:in `public_send'
# >> [self]   ActsAsTaggableOn::Tag Load (0.5ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99827349 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:108:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99827349 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:109:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99827349 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:110:in `block (2 levels) in record_to_row'
# >> [self]   ActsAsTaggableOn::Tag Load (0.5ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99827349 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [self]   ↳ app/models/quick_script/swars/battle_history_script.rb:111:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.6ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99827351 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:115:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.6ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99827351 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:116:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99827351 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:117:in `block (2 levels) in record_to_row'
# >> [opponent]   ActsAsTaggableOn::Tag Load (0.8ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 99827351 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >> [opponent]   ↳ app/models/quick_script/swars/battle_history_script.rb:118:in `block (2 levels) in record_to_row'
# >> 2024-07-25T04:53:33.559Z pid=98099 tid=1zf3 INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >>   TRANSACTION (0.3ms)  BEGIN
# >>   ↳ app/models/app_log.rb:102:in `call'
# >>   AppLog Create (1.1ms)  INSERT INTO `app_logs` (`level`, `emoji`, `subject`, `body`, `process_id`, `created_at`) VALUES ('important', '', '[GoogleApi][spreadsheet_create] 1nn8nY6yr1kq8cypU_nz1E4AJN9pXBKS3895-NxhFRuA', '', 98099, '2024-07-25 04:53:33')
# >>   ↳ app/models/app_log.rb:102:in `call'
# >>   TRANSACTION (0.9ms)  COMMIT
# >>   ↳ app/models/app_log.rb:102:in `call'
# >>   TRANSACTION (0.1ms)  BEGIN
# >>   ↳ app/models/google_api/facade.rb:13:in `call'
# >>   GoogleApi::ExpirationTracker Create (0.7ms)  INSERT INTO `google_api_expiration_trackers` (`spreadsheet_id`, `created_at`, `updated_at`) VALUES ('1nn8nY6yr1kq8cypU_nz1E4AJN9pXBKS3895-NxhFRuA', '2024-07-25 04:53:33.586156', '2024-07-25 04:53:33.586156')
# >>   ↳ app/models/google_api/facade.rb:13:in `call'
# >>   TRANSACTION (0.3ms)  COMMIT
# >>   ↳ app/models/google_api/facade.rb:13:in `call'
