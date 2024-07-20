require "./setup"
sql

# battle = Swars::Battle.create! do |e|
#   e.memberships.build
#   e.memberships.build
# end
# tp battle.memberships

battle = Swars::Battle.build
battle.memberships.build
battle.memberships.build
battle.save!
tp battle.memberships

# >>   TRANSACTION (0.3ms)  BEGIN
# >>   ↳ app/models/concerns/memory_record_bind.rb:107:in `block (3 levels) in <module:MemoryRecordBind>'
# >>   Preset Load (0.4ms)  SELECT `presets`.* FROM `presets` WHERE `presets`.`key` = '平手' ORDER BY `presets`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:22:in `db_record!'
# >>   Swars::Rule Load (0.4ms)  SELECT `swars_rules`.* FROM `swars_rules` WHERE `swars_rules`.`key` = 'ten_min' ORDER BY `swars_rules`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:22:in `db_record!'
# >>   Swars::Final Load (0.4ms)  SELECT `swars_finals`.* FROM `swars_finals` WHERE `swars_finals`.`key` = 'TORYO' ORDER BY `swars_finals`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:22:in `db_record!'
# >>   Swars::Xmode Load (0.3ms)  SELECT `swars_xmodes`.* FROM `swars_xmodes` WHERE `swars_xmodes`.`key` = '野良' ORDER BY `swars_xmodes`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:22:in `db_record!'
# >>   Swars::Rule Load (0.3ms)  SELECT `swars_rules`.* FROM `swars_rules` WHERE `swars_rules`.`id` = 1 ORDER BY `swars_rules`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:104:in `public_send'
# >>   Swars::Grade Load (0.3ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`key` = '30級' ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:22:in `db_record!'
# >>   Swars::Grade Count (1.0ms)  SELECT COUNT(*) FROM `swars_grades`
# >>   ↳ app/models/swars/user/grade_methods.rb:11:in `block (3 levels) in <class:User>'
# >>   Swars::User Count (48.5ms)  SELECT COUNT(*) FROM `swars_users`
# >>   ↳ app/models/swars/user.rb:69:in `block in <class:User>'
# >>   Swars::Grade Load (0.2ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` = 39 ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/swars/battle/basic_methods.rb:56:in `block (4 levels) in <class:Battle>'
# >>   Swars::User Create (0.4ms)  INSERT INTO `swars_users` (`user_key`, `grade_id`, `last_reception_at`, `search_logs_count`, `created_at`, `updated_at`, `ban_at`, `latest_battled_at`) VALUES ('user966974', 39, NULL, 0, '2024-07-20 00:41:56', '2024-07-20 00:41:56', NULL, '2024-07-20 00:41:56')
# >>   ↳ app/models/swars/battle/basic_methods.rb:56:in `block (4 levels) in <class:Battle>'
# >>   Swars::Profile Create (0.2ms)  INSERT INTO `swars_profiles` (`user_id`, `ban_at`, `ban_crawled_at`, `ban_crawled_count`, `created_at`, `updated_at`) VALUES (967061, NULL, '2024-07-20 00:41:56', 0, '2024-07-20 00:41:56', '2024-07-20 00:41:56')
# >>   ↳ app/models/swars/battle/basic_methods.rb:56:in `block (4 levels) in <class:Battle>'
# >>   Swars::Grade Load (0.2ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`key` = '30級' ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:22:in `db_record!'
# >>   Swars::Grade Count (0.4ms)  SELECT COUNT(*) FROM `swars_grades`
# >>   ↳ app/models/swars/user/grade_methods.rb:11:in `block (3 levels) in <class:User>'
# >>   Swars::User Count (22.2ms)  SELECT COUNT(*) FROM `swars_users`
# >>   ↳ app/models/swars/user.rb:69:in `block in <class:User>'
# >>   Swars::Grade Load (0.2ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` = 39 ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/swars/battle/basic_methods.rb:56:in `block (4 levels) in <class:Battle>'
# >>   Swars::User Create (0.3ms)  INSERT INTO `swars_users` (`user_key`, `grade_id`, `last_reception_at`, `search_logs_count`, `created_at`, `updated_at`, `ban_at`, `latest_battled_at`) VALUES ('user966975', 39, NULL, 0, '2024-07-20 00:41:56', '2024-07-20 00:41:56', NULL, '2024-07-20 00:41:56')
# >>   ↳ app/models/swars/battle/basic_methods.rb:56:in `block (4 levels) in <class:Battle>'
# >>   Swars::Profile Create (0.2ms)  INSERT INTO `swars_profiles` (`user_id`, `ban_at`, `ban_crawled_at`, `ban_crawled_count`, `created_at`, `updated_at`) VALUES (967062, NULL, '2024-07-20 00:41:56', 0, '2024-07-20 00:41:56', '2024-07-20 00:41:56')
# >>   ↳ app/models/swars/battle/basic_methods.rb:56:in `block (4 levels) in <class:Battle>'
# >>   Preset Load (0.2ms)  SELECT `presets`.* FROM `presets` WHERE `presets`.`id` = 1 ORDER BY `presets`.`position` ASC LIMIT 1
# >>   Location Load (0.2ms)  SELECT `locations`.* FROM `locations` WHERE `locations`.`key` = 'black' ORDER BY `locations`.`position` ASC LIMIT 1
# >>   ↳ app/models/concerns/memory_record_bind.rb:77:in `lookup'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`key` = 'win' ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/concerns/memory_record_bind.rb:77:in `lookup'
# >>   Swars::Membership Exists? (0.2ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`location_id` = 1 AND `swars_memberships`.`battle_id` IS NULL LIMIT 1
# >>   Swars::Membership Exists? (0.2ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`user_id` = 967061 AND `swars_memberships`.`battle_id` IS NULL LIMIT 1
# >>   Swars::Membership Exists? (0.2ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`op_user_id` = 967062 AND `swars_memberships`.`battle_id` IS NULL LIMIT 1
# >>   Location Load (0.2ms)  SELECT `locations`.* FROM `locations` WHERE `locations`.`key` = 'white' ORDER BY `locations`.`position` ASC LIMIT 1
# >>   ↳ app/models/concerns/memory_record_bind.rb:77:in `lookup'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`key` = 'lose' ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/concerns/memory_record_bind.rb:77:in `lookup'
# >>   Swars::Membership Exists? (0.2ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`location_id` = 2 AND `swars_memberships`.`battle_id` IS NULL LIMIT 1
# >>   Swars::Membership Exists? (0.1ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`user_id` = 967062 AND `swars_memberships`.`battle_id` IS NULL LIMIT 1
# >>   Swars::Membership Exists? (0.1ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`op_user_id` = 967061 AND `swars_memberships`.`battle_id` IS NULL LIMIT 1
# >>   Swars::Final Load (0.2ms)  SELECT `swars_finals`.* FROM `swars_finals` WHERE `swars_finals`.`id` = 1 ORDER BY `swars_finals`.`position` ASC LIMIT 1
# >>   Swars::Xmode Load (0.2ms)  SELECT `swars_xmodes`.* FROM `swars_xmodes` WHERE `swars_xmodes`.`id` = 1 ORDER BY `swars_xmodes`.`position` ASC LIMIT 1
# >>   Swars::Xmode Load (0.2ms)  SELECT `swars_xmodes`.* FROM `swars_xmodes` WHERE `swars_xmodes`.`key` = '指導' ORDER BY `swars_xmodes`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:22:in `db_record!'
# >>   Swars::Style Load (0.3ms)  SELECT `swars_styles`.* FROM `swars_styles` WHERE `swars_styles`.`key` = '王道' ORDER BY `swars_styles`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:22:in `db_record!'
# >>   Swars::Style Load (0.3ms)  SELECT `swars_styles`.* FROM `swars_styles` WHERE `swars_styles`.`key` = '準王道' ORDER BY `swars_styles`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:22:in `db_record!'
# >>   Swars::Battle Create (0.8ms)  INSERT INTO `swars_battles` (`key`, `battled_at`, `csa_seq`, `win_user_id`, `turn_max`, `meta_info`, `created_at`, `updated_at`, `start_turn`, `critical_turn`, `sfen_body`, `image_turn`, `outbreak_turn`, `accessed_at`, `sfen_hash`, `xmode_id`, `preset_id`, `rule_id`, `final_id`) VALUES ('f93eadb619f220bb64c9f919cc226d70', '2024-07-20 00:41:56', '---\n- - \"+7968GI\"\n  - 600\n- - \"-8232HI\"\n  - 600\n- - \"+5756FU\"\n  - 600\n- - \"-3334FU\"\n  - 600\n- - \"+6857GI\"\n  - 600\n', 967061, 5, '--- {}\n', '2024-07-20 00:41:56', '2024-07-20 00:41:56', NULL, NULL, 'position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7i6h 8b3b 5g5f 3c3d 6h5g', NULL, NULL, '2024-07-20 00:41:55', '7b7e2206a9d4cdf21d06bc390228ced8', 1, 1, 1, 1)
# >>   Swars::Membership Exists? (0.4ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`location_id` = 1 AND `swars_memberships`.`battle_id` = 50132169 LIMIT 1
# >>   Swars::Membership Exists? (0.3ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`user_id` = 967061 AND `swars_memberships`.`battle_id` = 50132169 LIMIT 1
# >>   Swars::Membership Exists? (0.3ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`op_user_id` = 967062 AND `swars_memberships`.`battle_id` = 50132169 LIMIT 1
# >>   Swars::Membership Load (0.6ms)  SELECT `swars_memberships`.* FROM `swars_memberships` WHERE `swars_memberships`.`battle_id` = 50132169 AND (`swars_memberships`.`position` IS NOT NULL) ORDER BY `swars_memberships`.`position` DESC LIMIT 1
# >>   Swars::Membership Create (0.7ms)  INSERT INTO `swars_memberships` (`battle_id`, `user_id`, `grade_id`, `position`, `created_at`, `updated_at`, `grade_diff`, `think_max`, `op_user_id`, `think_last`, `think_all_avg`, `think_end_avg`, `ai_drop_total`, `judge_id`, `location_id`, `style_id`, `ek_score_without_cond`, `ek_score_with_cond`, `ai_wave_count`, `ai_two_freq`, `ai_noizy_two_max`, `ai_gear_freq`, `opponent_id`) VALUES (50132169, 967061, 39, 0, '2024-07-20 00:41:56', '2024-07-20 00:41:56', 0, 0, 967062, 0, 0, 0, 0, 1, 1, 1, 0, NULL, 0, 0.0, 0, 0.0, NULL)
# >>   Swars::MembershipExtra Create (0.4ms)  INSERT INTO `swars_membership_extras` (`membership_id`, `used_piece_counts`, `created_at`, `updated_at`) VALUES (100028913, '{\"S0\":2,\"P0\":1}', '2024-07-20 00:41:56.332908', '2024-07-20 00:41:56.332908')
# >>   ActsAsTaggableOn::Tag Load (1.0ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 100028913 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (47.6ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('新嬉野流'))
# >>   ActsAsTaggableOn::Tag Load (0.5ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 100028913 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (0.2ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` = 201090 LIMIT 1
# >>   ActsAsTaggableOn::Tagging Exists? (0.3ms)  SELECT 1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 201090 AND `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` = 100028913 AND `taggings`.`context` = 'attack_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ActsAsTaggableOn::Tagging Create (0.3ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `tagger_type`, `tagger_id`, `context`, `created_at`) VALUES (201090, 'Swars::Membership', 100028913, NULL, NULL, 'attack_tags', '2024-07-20 00:41:56')
# >>   ActsAsTaggableOn::Tag Update All (0.3ms)  UPDATE `tags` SET `tags`.`taggings_count` = COALESCE(`tags`.`taggings_count`, 0) + 1 WHERE `tags`.`id` = 201090
# >>   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 100028913 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (34.0ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('対振り飛車') OR LOWER(name) = LOWER('居飛車') OR LOWER(name) = LOWER('対抗形'))
# >>   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 100028913 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (0.2ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` = 122779 LIMIT 1
# >>   ActsAsTaggableOn::Tagging Exists? (0.3ms)  SELECT 1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 122779 AND `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` = 100028913 AND `taggings`.`context` = 'note_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ActsAsTaggableOn::Tagging Create (0.2ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `tagger_type`, `tagger_id`, `context`, `created_at`) VALUES (122779, 'Swars::Membership', 100028913, NULL, NULL, 'note_tags', '2024-07-20 00:41:56')
# >>   ActsAsTaggableOn::Tag Update All (0.2ms)  UPDATE `tags` SET `tags`.`taggings_count` = COALESCE(`tags`.`taggings_count`, 0) + 1 WHERE `tags`.`id` = 122779
# >>   ActsAsTaggableOn::Tag Load (0.1ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` = 122778 LIMIT 1
# >>   ActsAsTaggableOn::Tagging Exists? (0.3ms)  SELECT 1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 122778 AND `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` = 100028913 AND `taggings`.`context` = 'note_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ActsAsTaggableOn::Tagging Create (0.2ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `tagger_type`, `tagger_id`, `context`, `created_at`) VALUES (122778, 'Swars::Membership', 100028913, NULL, NULL, 'note_tags', '2024-07-20 00:41:56')
# >>   ActsAsTaggableOn::Tag Update All (0.2ms)  UPDATE `tags` SET `tags`.`taggings_count` = COALESCE(`tags`.`taggings_count`, 0) + 1 WHERE `tags`.`id` = 122778
# >>   ActsAsTaggableOn::Tag Load (0.2ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` = 122777 LIMIT 1
# >>   ActsAsTaggableOn::Tagging Exists? (0.4ms)  SELECT 1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 122777 AND `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` = 100028913 AND `taggings`.`context` = 'note_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ActsAsTaggableOn::Tagging Create (0.2ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `tagger_type`, `tagger_id`, `context`, `created_at`) VALUES (122777, 'Swars::Membership', 100028913, NULL, NULL, 'note_tags', '2024-07-20 00:41:56')
# >>   ActsAsTaggableOn::Tag Update All (0.4ms)  UPDATE `tags` SET `tags`.`taggings_count` = COALESCE(`tags`.`taggings_count`, 0) + 1 WHERE `tags`.`id` = 122777
# >>   Swars::Membership Exists? (0.2ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`location_id` = 2 AND `swars_memberships`.`battle_id` = 50132169 LIMIT 1
# >>   Swars::Membership Exists? (0.1ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`user_id` = 967062 AND `swars_memberships`.`battle_id` = 50132169 LIMIT 1
# >>   Swars::Membership Exists? (0.1ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`op_user_id` = 967061 AND `swars_memberships`.`battle_id` = 50132169 LIMIT 1
# >>   Swars::Membership Load (0.3ms)  SELECT `swars_memberships`.* FROM `swars_memberships` WHERE `swars_memberships`.`battle_id` = 50132169 AND (`swars_memberships`.`position` IS NOT NULL) ORDER BY `swars_memberships`.`position` DESC LIMIT 1
# >>   Swars::Membership Create (0.3ms)  INSERT INTO `swars_memberships` (`battle_id`, `user_id`, `grade_id`, `position`, `created_at`, `updated_at`, `grade_diff`, `think_max`, `op_user_id`, `think_last`, `think_all_avg`, `think_end_avg`, `ai_drop_total`, `judge_id`, `location_id`, `style_id`, `ek_score_without_cond`, `ek_score_with_cond`, `ai_wave_count`, `ai_two_freq`, `ai_noizy_two_max`, `ai_gear_freq`, `opponent_id`) VALUES (50132169, 967062, 39, 1, '2024-07-20 00:41:56', '2024-07-20 00:41:56', 0, 0, 967061, 0, 0, 0, 0, 2, 2, 2, 0, NULL, 0, 0.0, 0, 0.0, NULL)
# >>   Swars::MembershipExtra Create (0.2ms)  INSERT INTO `swars_membership_extras` (`membership_id`, `used_piece_counts`, `created_at`, `updated_at`) VALUES (100028914, '{\"R0\":1,\"P0\":1}', '2024-07-20 00:41:56.453092', '2024-07-20 00:41:56.453092')
# >>   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 100028914 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (19.9ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('2手目△３ニ飛戦法'))
# >>   ActsAsTaggableOn::Tag Load (0.2ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 100028914 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (0.1ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` = 1570 LIMIT 1
# >>   ActsAsTaggableOn::Tagging Exists? (0.3ms)  SELECT 1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 1570 AND `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` = 100028914 AND `taggings`.`context` = 'attack_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ActsAsTaggableOn::Tagging Create (1.9ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `tagger_type`, `tagger_id`, `context`, `created_at`) VALUES (1570, 'Swars::Membership', 100028914, NULL, NULL, 'attack_tags', '2024-07-20 00:41:56')
# >>   ActsAsTaggableOn::Tag Update All (0.2ms)  UPDATE `tags` SET `tags`.`taggings_count` = COALESCE(`tags`.`taggings_count`, 0) + 1 WHERE `tags`.`id` = 1570
# >>   ActsAsTaggableOn::Tag Load (0.2ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 100028914 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (30.9ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('振り飛車') OR LOWER(name) = LOWER('対居飛車') OR LOWER(name) = LOWER('対抗形'))
# >>   ActsAsTaggableOn::Tag Load (0.2ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 100028914 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (0.1ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` = 122776 LIMIT 1
# >>   ActsAsTaggableOn::Tagging Exists? (0.2ms)  SELECT 1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 122776 AND `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` = 100028914 AND `taggings`.`context` = 'note_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ActsAsTaggableOn::Tagging Create (0.2ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `tagger_type`, `tagger_id`, `context`, `created_at`) VALUES (122776, 'Swars::Membership', 100028914, NULL, NULL, 'note_tags', '2024-07-20 00:41:56')
# >>   ActsAsTaggableOn::Tag Update All (0.2ms)  UPDATE `tags` SET `tags`.`taggings_count` = COALESCE(`tags`.`taggings_count`, 0) + 1 WHERE `tags`.`id` = 122776
# >>   ActsAsTaggableOn::Tag Load (0.1ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` = 201273 LIMIT 1
# >>   ActsAsTaggableOn::Tagging Exists? (0.2ms)  SELECT 1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 201273 AND `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` = 100028914 AND `taggings`.`context` = 'note_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ActsAsTaggableOn::Tagging Create (0.2ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `tagger_type`, `tagger_id`, `context`, `created_at`) VALUES (201273, 'Swars::Membership', 100028914, NULL, NULL, 'note_tags', '2024-07-20 00:41:56')
# >>   ActsAsTaggableOn::Tag Update All (0.1ms)  UPDATE `tags` SET `tags`.`taggings_count` = COALESCE(`tags`.`taggings_count`, 0) + 1 WHERE `tags`.`id` = 201273
# >>   ActsAsTaggableOn::Tag Load (0.1ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` = 122777 LIMIT 1
# >>   ActsAsTaggableOn::Tagging Exists? (0.2ms)  SELECT 1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 122777 AND `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` = 100028914 AND `taggings`.`context` = 'note_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ActsAsTaggableOn::Tagging Create (0.2ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `tagger_type`, `tagger_id`, `context`, `created_at`) VALUES (122777, 'Swars::Membership', 100028914, NULL, NULL, 'note_tags', '2024-07-20 00:41:56')
# >>   ActsAsTaggableOn::Tag Update All (0.1ms)  UPDATE `tags` SET `tags`.`taggings_count` = COALESCE(`tags`.`taggings_count`, 0) + 1 WHERE `tags`.`id` = 122777
# >>   Swars::User Load (0.2ms)  SELECT `swars_users`.* FROM `swars_users` INNER JOIN `swars_memberships` ON `swars_users`.`id` = `swars_memberships`.`user_id` WHERE `swars_memberships`.`battle_id` = 50132169 ORDER BY `swars_memberships`.`position` ASC
# >>   ↳ app/models/swars/battle/basic_methods.rb:100:in `block (3 levels) in <class:Battle>'
# >>   Swars::Grade Count (0.4ms)  SELECT COUNT(*) FROM `swars_grades`
# >>   ↳ app/models/swars/user/grade_methods.rb:11:in `block (3 levels) in <class:User>'
# >>   Swars::Grade Load (0.2ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` = 39 ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/swars/battle/basic_methods.rb:101:in `block (4 levels) in <class:Battle>'
# >>   Swars::Grade Count (0.3ms)  SELECT COUNT(*) FROM `swars_grades`
# >>   ↳ app/models/swars/user/grade_methods.rb:11:in `block (3 levels) in <class:User>'
# >>   Swars::Grade Load (0.2ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` = 39 ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/swars/battle/basic_methods.rb:101:in `block (4 levels) in <class:Battle>'
# >>   ActsAsTaggableOn::Tagging Load (0.2ms)  SELECT `taggings`.* FROM `taggings` WHERE `taggings`.`taggable_id` = 50132169 AND `taggings`.`taggable_type` = 'Swars::Battle'
# >>   TRANSACTION (0.4ms)  COMMIT
# >> |-----------+-----------+---------+----------+----------+---------------------------+---------------------------+------------+-----------+------------+------------+---------------+---------------+---------------+----------+-------------+----------+-----------------------+--------------------+---------------+-------------+------------------+--------------+-------------+------------------+-------------------+--------------------+--------------------------|
# >> | id        | battle_id | user_id | grade_id | position | created_at                | updated_at                | grade_diff | think_max | op_user_id | think_last | think_all_avg | think_end_avg | ai_drop_total | judge_id | location_id | style_id | ek_score_without_cond | ek_score_with_cond | ai_wave_count | ai_two_freq | ai_noizy_two_max | ai_gear_freq | opponent_id | defense_tag_list | attack_tag_list   | technique_tag_list | note_tag_list            |
# >> |-----------+-----------+---------+----------+----------+---------------------------+---------------------------+------------+-----------+------------+------------+---------------+---------------+---------------+----------+-------------+----------+-----------------------+--------------------+---------------+-------------+------------------+--------------+-------------+------------------+-------------------+--------------------+--------------------------|
# >> | 100028913 |  50132169 |  967061 |       39 |        0 | 2024-07-20 09:41:56 +0900 | 2024-07-20 09:41:56 +0900 |          0 |         0 |     967062 |          0 |             0 |             0 |             0 |        1 |           1 |        1 |                     0 |                    |             0 |         0.0 |                0 |          0.0 |   100028914 |                  | 新嬉野流          |                    | 対振り飛車 居飛車 対抗形 |
# >> | 100028914 |  50132169 |  967062 |       39 |        1 | 2024-07-20 09:41:56 +0900 | 2024-07-20 09:41:56 +0900 |          0 |         0 |     967061 |          0 |             0 |             0 |             0 |        2 |           2 |        2 |                     0 |                    |             0 |         0.0 |                0 |          0.0 |   100028913 |                  | 2手目△３ニ飛戦法 |                    | 振り飛車 対居飛車 対抗形 |
# >> |-----------+-----------+---------+----------+----------+---------------------------+---------------------------+------------+-----------+------------+------------+---------------+---------------+---------------+----------+-------------+----------+-----------------------+--------------------+---------------+-------------+------------------+--------------+-------------+------------------+-------------------+--------------------+--------------------------|
