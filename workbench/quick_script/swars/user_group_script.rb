require "./setup"
sql
user_key = SecureRandom.hex
alice = Swars::User.create!(key: user_key)
2.times do
  Swars::Battle.create! do |e|
    e.memberships.build(user: alice)
  end
end
instance = QuickScript::Swars::UserGroupScript.new({ user_items_text: "(xname) #{user_key}" }, { _method: "post" })
instance.current_user_keys   # => ["af573f28cae329bd938e60b2d3887056"]
instance.db_exist_user_keys  # => ["af573f28cae329bd938e60b2d3887056"]
tp instance.rows

# sql
# user_key = SecureRandom.hex
# alice = Swars::User.create!(key: user_key)
# Swars::Battle.create! do |e|
#   e.memberships.build(user: alice)
# end
# QuickScript::Swars::UserGroupScript.new(user_items_text: user_key).call[:_v_bind][:value][:rows].size # => 1
#
# GoogleApi::ExpirationTracker.destroy_all
# QuickScript::Swars::UserGroupScript.new(user_items_text: user_key, google_sheet: true).call
# GoogleApi::ExpirationTracker.count          # => 1
# GoogleApi::ExpirationTracker.destroy_all

# >>   TRANSACTION (0.3ms)  BEGIN
# >>   ↳ app/models/swars/grade.rb:46:in `block (3 levels) in <class:Grade>'
# >>   Swars::Grade Load (0.6ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`key` = '30級' ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:36:in `db_record!'
# >>   Swars::Grade Count (0.3ms)  SELECT COUNT(*) FROM `swars_grades`
# >>   ↳ app/models/swars/user/grade_methods.rb:11:in `block (3 levels) in <class:User>'
# >>   Swars::Grade Load (0.4ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` = 39 ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   Swars::User Create (2.2ms)  INSERT INTO `swars_users` (`user_key`, `grade_id`, `last_reception_at`, `search_logs_count`, `created_at`, `updated_at`, `ban_at`, `latest_battled_at`, `soft_crawled_at`, `hard_crawled_at`) VALUES ('af573f28cae329bd938e60b2d3887056', 39, NULL, 0, '2024-11-27 12:49:44', '2024-11-27 12:49:44', NULL, '2024-11-27 12:49:44', '2024-11-27 12:49:44', '2024-11-27 12:49:44')
# >>   Swars::Profile Create (0.5ms)  INSERT INTO `swars_profiles` (`user_id`, `ban_at`, `ban_crawled_at`, `ban_crawled_count`, `created_at`, `updated_at`) VALUES (1011737, NULL, '2024-11-27 12:49:44', 0, '2024-11-27 12:49:44', '2024-11-27 12:49:44')
# >>   TRANSACTION (1.6ms)  COMMIT
# >>   TRANSACTION (0.4ms)  BEGIN
# >>   ↳ app/models/concerns/memory_record_bind.rb:107:in `block (3 levels) in <module:MemoryRecordBind>'
# >>   Preset Load (0.4ms)  SELECT `presets`.* FROM `presets` WHERE `presets`.`key` = '平手' ORDER BY `presets`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:36:in `db_record!'
# >>   Swars::Rule Load (0.4ms)  SELECT `swars_rules`.* FROM `swars_rules` WHERE `swars_rules`.`key` = 'ten_min' ORDER BY `swars_rules`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:36:in `db_record!'
# >>   Swars::Final Load (0.4ms)  SELECT `swars_finals`.* FROM `swars_finals` WHERE `swars_finals`.`key` = 'TORYO' ORDER BY `swars_finals`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:36:in `db_record!'
# >>   Swars::Xmode Load (0.5ms)  SELECT `swars_xmodes`.* FROM `swars_xmodes` WHERE `swars_xmodes`.`key` = '野良' ORDER BY `swars_xmodes`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:36:in `db_record!'
# >>   Swars::Rule Load (0.3ms)  SELECT `swars_rules`.* FROM `swars_rules` WHERE `swars_rules`.`id` = 1 ORDER BY `swars_rules`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:104:in `public_send'
# >>   Swars::Grade Load (0.2ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`key` = '30級' ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:36:in `db_record!'
# >>   Swars::Grade Count (0.1ms)  SELECT COUNT(*) FROM `swars_grades`
# >>   ↳ app/models/swars/user/grade_methods.rb:11:in `block (3 levels) in <class:User>'
# >>   Swars::User Count (121.8ms)  SELECT COUNT(*) FROM `swars_users`
# >>   ↳ app/models/swars/user.rb:68:in `block in <class:User>'
# >>   Swars::Grade Load (0.4ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` = 39 ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/swars/battle/basic_methods.rb:67:in `block (4 levels) in <class:Battle>'
# >>   Swars::User Create (0.4ms)  INSERT INTO `swars_users` (`user_key`, `grade_id`, `last_reception_at`, `search_logs_count`, `created_at`, `updated_at`, `ban_at`, `latest_battled_at`, `soft_crawled_at`, `hard_crawled_at`) VALUES ('user1011679', 39, NULL, 0, '2024-11-27 12:49:45', '2024-11-27 12:49:45', NULL, '2024-11-27 12:49:45', '2024-11-27 12:49:45', '2024-11-27 12:49:45')
# >>   ↳ app/models/swars/battle/basic_methods.rb:67:in `block (4 levels) in <class:Battle>'
# >>   Swars::Profile Create (0.5ms)  INSERT INTO `swars_profiles` (`user_id`, `ban_at`, `ban_crawled_at`, `ban_crawled_count`, `created_at`, `updated_at`) VALUES (1011738, NULL, '2024-11-27 12:49:45', 0, '2024-11-27 12:49:45', '2024-11-27 12:49:45')
# >>   ↳ app/models/swars/battle/basic_methods.rb:67:in `block (4 levels) in <class:Battle>'
# >>   Preset Load (0.2ms)  SELECT `presets`.* FROM `presets` WHERE `presets`.`id` = 1 ORDER BY `presets`.`position` ASC LIMIT 1
# >>   Location Load (0.3ms)  SELECT `locations`.* FROM `locations` WHERE `locations`.`key` = 'black' ORDER BY `locations`.`position` ASC LIMIT 1
# >>   ↳ app/models/concerns/memory_record_bind.rb:77:in `lookup'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`key` = 'win' ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/concerns/memory_record_bind.rb:77:in `lookup'
# >>   Swars::Membership Exists? (0.5ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`location_id` = 1 AND `swars_memberships`.`battle_id` IS NULL LIMIT 1
# >>   Swars::Membership Exists? (0.1ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`user_id` = 1011737 AND `swars_memberships`.`battle_id` IS NULL LIMIT 1
# >>   Swars::Membership Exists? (0.1ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`op_user_id` = 1011738 AND `swars_memberships`.`battle_id` IS NULL LIMIT 1
# >>   Location Load (0.1ms)  SELECT `locations`.* FROM `locations` WHERE `locations`.`key` = 'white' ORDER BY `locations`.`position` ASC LIMIT 1
# >>   ↳ app/models/concerns/memory_record_bind.rb:77:in `lookup'
# >>   Judge Load (0.1ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`key` = 'lose' ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/concerns/memory_record_bind.rb:77:in `lookup'
# >>   Swars::Membership Exists? (0.1ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`location_id` = 2 AND `swars_memberships`.`battle_id` IS NULL LIMIT 1
# >>   Swars::Membership Exists? (0.1ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`user_id` = 1011738 AND `swars_memberships`.`battle_id` IS NULL LIMIT 1
# >>   Swars::Membership Exists? (0.1ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`op_user_id` = 1011737 AND `swars_memberships`.`battle_id` IS NULL LIMIT 1
# >>   Swars::Final Load (0.1ms)  SELECT `swars_finals`.* FROM `swars_finals` WHERE `swars_finals`.`id` = 1 ORDER BY `swars_finals`.`position` ASC LIMIT 1
# >>   Swars::Xmode Load (0.1ms)  SELECT `swars_xmodes`.* FROM `swars_xmodes` WHERE `swars_xmodes`.`id` = 1 ORDER BY `swars_xmodes`.`position` ASC LIMIT 1
# >>   Swars::Xmode Load (0.1ms)  SELECT `swars_xmodes`.* FROM `swars_xmodes` WHERE `swars_xmodes`.`key` = '指導' ORDER BY `swars_xmodes`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:36:in `db_record!'
# >>   Swars::Style Load (0.4ms)  SELECT `swars_styles`.* FROM `swars_styles` WHERE `swars_styles`.`key` = '王道' ORDER BY `swars_styles`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:36:in `db_record!'
# >>   Swars::Style Load (0.2ms)  SELECT `swars_styles`.* FROM `swars_styles` WHERE `swars_styles`.`key` = '準王道' ORDER BY `swars_styles`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:36:in `db_record!'
# >>   Swars::Battle Create (2.2ms)  INSERT INTO `swars_battles` (`key`, `battled_at`, `csa_seq`, `win_user_id`, `turn_max`, `meta_info`, `created_at`, `updated_at`, `start_turn`, `critical_turn`, `sfen_body`, `image_turn`, `outbreak_turn`, `accessed_at`, `sfen_hash`, `xmode_id`, `preset_id`, `rule_id`, `final_id`, `analysis_version`) VALUES ('0c0b85f392d2e5674d9a97ba590c455c', '2024-11-27 12:49:45', '---\n- - \"+7968GI\"\n  - 600\n- - \"-8232HI\"\n  - 600\n- - \"+5756FU\"\n  - 600\n- - \"-3334FU\"\n  - 600\n- - \"+6857GI\"\n  - 600\n', 1011737, 5, '--- {}\n', '2024-11-27 12:49:45', '2024-11-27 12:49:45', NULL, NULL, 'position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7i6h 8b3b 5g5f 3c3d 6h5g', NULL, NULL, '2024-11-27 12:49:45', '7b7e2206a9d4cdf21d06bc390228ced8', 1, 1, 1, 1, 3)
# >>   Swars::Membership Exists? (0.7ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`location_id` = 1 AND `swars_memberships`.`battle_id` = 54651566 LIMIT 1
# >>   Swars::Membership Exists? (1.8ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`user_id` = 1011737 AND `swars_memberships`.`battle_id` = 54651566 LIMIT 1
# >>   Swars::Membership Exists? (0.3ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`op_user_id` = 1011738 AND `swars_memberships`.`battle_id` = 54651566 LIMIT 1
# >>   Swars::Membership Load (1.2ms)  SELECT `swars_memberships`.* FROM `swars_memberships` WHERE `swars_memberships`.`battle_id` = 54651566 AND (`swars_memberships`.`position` IS NOT NULL) ORDER BY `swars_memberships`.`position` DESC LIMIT 1
# >>   Swars::Membership Create (1.0ms)  INSERT INTO `swars_memberships` (`battle_id`, `user_id`, `grade_id`, `position`, `created_at`, `updated_at`, `grade_diff`, `think_max`, `op_user_id`, `think_last`, `think_all_avg`, `think_end_avg`, `ai_drop_total`, `judge_id`, `location_id`, `style_id`, `ek_score_without_cond`, `ek_score_with_cond`, `ai_wave_count`, `ai_two_freq`, `ai_noizy_two_max`, `ai_gear_freq`, `opponent_id`) VALUES (54651566, 1011737, 39, 0, '2024-11-27 12:49:45', '2024-11-27 12:49:45', 0, 0, 1011738, 0, 0, 0, 0, 1, 1, 1, 0, NULL, 0, 0.0, 0, 0.0, NULL)
# >>   Swars::User Update (0.6ms)  UPDATE `swars_users` SET `swars_users`.`latest_battled_at` = '2024-11-27 12:49:45' WHERE `swars_users`.`id` = 1011737
# >>   ↳ app/models/swars/membership.rb:160:in `block in <class:Membership>'
# >>   Swars::MembershipExtra Create (0.5ms)  INSERT INTO `swars_membership_extras` (`membership_id`, `used_piece_counts`, `created_at`, `updated_at`) VALUES (108956823, '{\"S0\":2,\"P0\":1}', '2024-11-27 12:49:45.443776', '2024-11-27 12:49:45.443776')
# >>   ActsAsTaggableOn::Tag Load (1.9ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 108956823 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (36.6ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('新嬉野流'))
# >>   ActsAsTaggableOn::Tag Load (0.8ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 108956823 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` = 201090 LIMIT 1
# >>   ActsAsTaggableOn::Tagging Exists? (0.5ms)  SELECT 1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 201090 AND `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` = 108956823 AND `taggings`.`context` = 'attack_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ActsAsTaggableOn::Tagging Create (0.4ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `tagger_type`, `tagger_id`, `context`, `created_at`) VALUES (201090, 'Swars::Membership', 108956823, NULL, NULL, 'attack_tags', '2024-11-27 12:49:45')
# >>   ActsAsTaggableOn::Tag Update All (0.2ms)  UPDATE `tags` SET `tags`.`taggings_count` = COALESCE(`tags`.`taggings_count`, 0) + 1 WHERE `tags`.`id` = 201090
# >>   ActsAsTaggableOn::Tag Load (0.4ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 108956823 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (27.2ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('対振り飛車') OR LOWER(name) = LOWER('対抗形'))
# >>   ActsAsTaggableOn::Tag Load (1.2ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 108956823 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (0.6ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` = 122779 LIMIT 1
# >>   ActsAsTaggableOn::Tagging Exists? (0.7ms)  SELECT 1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 122779 AND `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` = 108956823 AND `taggings`.`context` = 'note_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ActsAsTaggableOn::Tagging Create (0.3ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `tagger_type`, `tagger_id`, `context`, `created_at`) VALUES (122779, 'Swars::Membership', 108956823, NULL, NULL, 'note_tags', '2024-11-27 12:49:45')
# >>   ActsAsTaggableOn::Tag Update All (0.3ms)  UPDATE `tags` SET `tags`.`taggings_count` = COALESCE(`tags`.`taggings_count`, 0) + 1 WHERE `tags`.`id` = 122779
# >>   ActsAsTaggableOn::Tag Load (0.2ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` = 122777 LIMIT 1
# >>   ActsAsTaggableOn::Tagging Exists? (0.5ms)  SELECT 1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 122777 AND `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` = 108956823 AND `taggings`.`context` = 'note_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ActsAsTaggableOn::Tagging Create (0.2ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `tagger_type`, `tagger_id`, `context`, `created_at`) VALUES (122777, 'Swars::Membership', 108956823, NULL, NULL, 'note_tags', '2024-11-27 12:49:45')
# >>   ActsAsTaggableOn::Tag Update All (0.3ms)  UPDATE `tags` SET `tags`.`taggings_count` = COALESCE(`tags`.`taggings_count`, 0) + 1 WHERE `tags`.`id` = 122777
# >>   Swars::Membership Exists? (0.2ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`location_id` = 2 AND `swars_memberships`.`battle_id` = 54651566 LIMIT 1
# >>   Swars::Membership Exists? (0.1ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`user_id` = 1011738 AND `swars_memberships`.`battle_id` = 54651566 LIMIT 1
# >>   Swars::Membership Exists? (0.2ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`op_user_id` = 1011737 AND `swars_memberships`.`battle_id` = 54651566 LIMIT 1
# >>   Swars::Membership Load (0.3ms)  SELECT `swars_memberships`.* FROM `swars_memberships` WHERE `swars_memberships`.`battle_id` = 54651566 AND (`swars_memberships`.`position` IS NOT NULL) ORDER BY `swars_memberships`.`position` DESC LIMIT 1
# >>   Swars::Membership Create (0.3ms)  INSERT INTO `swars_memberships` (`battle_id`, `user_id`, `grade_id`, `position`, `created_at`, `updated_at`, `grade_diff`, `think_max`, `op_user_id`, `think_last`, `think_all_avg`, `think_end_avg`, `ai_drop_total`, `judge_id`, `location_id`, `style_id`, `ek_score_without_cond`, `ek_score_with_cond`, `ai_wave_count`, `ai_two_freq`, `ai_noizy_two_max`, `ai_gear_freq`, `opponent_id`) VALUES (54651566, 1011738, 39, 1, '2024-11-27 12:49:45', '2024-11-27 12:49:45', 0, 0, 1011737, 0, 0, 0, 0, 2, 2, 2, 0, NULL, 0, 0.0, 0, 0.0, NULL)
# >>   Swars::MembershipExtra Create (0.1ms)  INSERT INTO `swars_membership_extras` (`membership_id`, `used_piece_counts`, `created_at`, `updated_at`) VALUES (108956824, '{\"R0\":1,\"P0\":1}', '2024-11-27 12:49:45.557035', '2024-11-27 12:49:45.557035')
# >>   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 108956824 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (20.8ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('2手目△3ニ飛戦法'))
# >>   ActsAsTaggableOn::Tag Load (0.4ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 108956824 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (0.1ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` = 1570 LIMIT 1
# >>   ActsAsTaggableOn::Tagging Exists? (0.4ms)  SELECT 1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 1570 AND `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` = 108956824 AND `taggings`.`context` = 'attack_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ActsAsTaggableOn::Tagging Create (0.2ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `tagger_type`, `tagger_id`, `context`, `created_at`) VALUES (1570, 'Swars::Membership', 108956824, NULL, NULL, 'attack_tags', '2024-11-27 12:49:45')
# >>   ActsAsTaggableOn::Tag Update All (0.2ms)  UPDATE `tags` SET `tags`.`taggings_count` = COALESCE(`tags`.`taggings_count`, 0) + 1 WHERE `tags`.`id` = 1570
# >>   ActsAsTaggableOn::Tag Load (0.2ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 108956824 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (27.4ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('振り飛車') OR LOWER(name) = LOWER('対抗形'))
# >>   ActsAsTaggableOn::Tag Load (0.5ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 108956824 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (0.2ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` = 122776 LIMIT 1
# >>   ActsAsTaggableOn::Tagging Exists? (0.5ms)  SELECT 1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 122776 AND `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` = 108956824 AND `taggings`.`context` = 'note_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ActsAsTaggableOn::Tagging Create (0.3ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `tagger_type`, `tagger_id`, `context`, `created_at`) VALUES (122776, 'Swars::Membership', 108956824, NULL, NULL, 'note_tags', '2024-11-27 12:49:45')
# >>   ActsAsTaggableOn::Tag Update All (0.2ms)  UPDATE `tags` SET `tags`.`taggings_count` = COALESCE(`tags`.`taggings_count`, 0) + 1 WHERE `tags`.`id` = 122776
# >>   ActsAsTaggableOn::Tag Load (0.1ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` = 122777 LIMIT 1
# >>   ActsAsTaggableOn::Tagging Exists? (0.3ms)  SELECT 1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 122777 AND `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` = 108956824 AND `taggings`.`context` = 'note_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ActsAsTaggableOn::Tagging Create (0.2ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `tagger_type`, `tagger_id`, `context`, `created_at`) VALUES (122777, 'Swars::Membership', 108956824, NULL, NULL, 'note_tags', '2024-11-27 12:49:45')
# >>   ActsAsTaggableOn::Tag Update All (0.2ms)  UPDATE `tags` SET `tags`.`taggings_count` = COALESCE(`tags`.`taggings_count`, 0) + 1 WHERE `tags`.`id` = 122777
# >>   Swars::Membership Update (0.4ms)  UPDATE `swars_memberships` SET `swars_memberships`.`opponent_id` = 108956824 WHERE `swars_memberships`.`id` = 108956823
# >>   ↳ app/models/swars/battle/basic_methods.rb:104:in `block (3 levels) in <class:Battle>'
# >>   Swars::Membership Update (0.2ms)  UPDATE `swars_memberships` SET `swars_memberships`.`opponent_id` = 108956823 WHERE `swars_memberships`.`id` = 108956824
# >>   ↳ app/models/swars/battle/basic_methods.rb:105:in `block (3 levels) in <class:Battle>'
# >>   ActsAsTaggableOn::Tagging Load (0.8ms)  SELECT `taggings`.* FROM `taggings` WHERE `taggings`.`taggable_id` = 54651566 AND `taggings`.`taggable_type` = 'Swars::Battle'
# >>   TRANSACTION (0.7ms)  COMMIT
# >>   TRANSACTION (0.1ms)  BEGIN
# >>   ↳ app/models/application_memory_record.rb:36:in `db_record!'
# >>   Preset Load (0.5ms)  SELECT `presets`.* FROM `presets` WHERE `presets`.`key` = '平手' ORDER BY `presets`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:36:in `db_record!'
# >>   Swars::Rule Load (0.1ms)  SELECT `swars_rules`.* FROM `swars_rules` WHERE `swars_rules`.`key` = 'ten_min' ORDER BY `swars_rules`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:36:in `db_record!'
# >>   Swars::Final Load (0.2ms)  SELECT `swars_finals`.* FROM `swars_finals` WHERE `swars_finals`.`key` = 'TORYO' ORDER BY `swars_finals`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:36:in `db_record!'
# >>   Swars::Xmode Load (0.1ms)  SELECT `swars_xmodes`.* FROM `swars_xmodes` WHERE `swars_xmodes`.`key` = '野良' ORDER BY `swars_xmodes`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:36:in `db_record!'
# >>   Swars::Rule Load (0.1ms)  SELECT `swars_rules`.* FROM `swars_rules` WHERE `swars_rules`.`id` = 1 ORDER BY `swars_rules`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:104:in `public_send'
# >>   Swars::Grade Load (0.1ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`key` = '30級' ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:36:in `db_record!'
# >>   Swars::Grade Count (0.1ms)  SELECT COUNT(*) FROM `swars_grades`
# >>   ↳ app/models/swars/user/grade_methods.rb:11:in `block (3 levels) in <class:User>'
# >>   Swars::User Count (95.8ms)  SELECT COUNT(*) FROM `swars_users`
# >>   ↳ app/models/swars/user.rb:68:in `block in <class:User>'
# >>   Swars::Grade Load (0.2ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` = 39 ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/swars/battle/basic_methods.rb:67:in `block (4 levels) in <class:Battle>'
# >>   Swars::User Create (0.3ms)  INSERT INTO `swars_users` (`user_key`, `grade_id`, `last_reception_at`, `search_logs_count`, `created_at`, `updated_at`, `ban_at`, `latest_battled_at`, `soft_crawled_at`, `hard_crawled_at`) VALUES ('user1011680', 39, NULL, 0, '2024-11-27 12:49:45', '2024-11-27 12:49:45', NULL, '2024-11-27 12:49:45', '2024-11-27 12:49:45', '2024-11-27 12:49:45')
# >>   ↳ app/models/swars/battle/basic_methods.rb:67:in `block (4 levels) in <class:Battle>'
# >>   Swars::Profile Create (0.2ms)  INSERT INTO `swars_profiles` (`user_id`, `ban_at`, `ban_crawled_at`, `ban_crawled_count`, `created_at`, `updated_at`) VALUES (1011739, NULL, '2024-11-27 12:49:45', 0, '2024-11-27 12:49:45', '2024-11-27 12:49:45')
# >>   ↳ app/models/swars/battle/basic_methods.rb:67:in `block (4 levels) in <class:Battle>'
# >>   Preset Load (0.1ms)  SELECT `presets`.* FROM `presets` WHERE `presets`.`id` = 1 ORDER BY `presets`.`position` ASC LIMIT 1
# >>   Location Load (0.1ms)  SELECT `locations`.* FROM `locations` WHERE `locations`.`key` = 'black' ORDER BY `locations`.`position` ASC LIMIT 1
# >>   ↳ app/models/concerns/memory_record_bind.rb:77:in `lookup'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`key` = 'win' ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/concerns/memory_record_bind.rb:77:in `lookup'
# >>   Swars::Membership Exists? (0.2ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`location_id` = 1 AND `swars_memberships`.`battle_id` IS NULL LIMIT 1
# >>   Swars::Membership Exists? (0.1ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`user_id` = 1011737 AND `swars_memberships`.`battle_id` IS NULL LIMIT 1
# >>   Swars::Membership Exists? (0.1ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`op_user_id` = 1011739 AND `swars_memberships`.`battle_id` IS NULL LIMIT 1
# >>   Location Load (0.1ms)  SELECT `locations`.* FROM `locations` WHERE `locations`.`key` = 'white' ORDER BY `locations`.`position` ASC LIMIT 1
# >>   ↳ app/models/concerns/memory_record_bind.rb:77:in `lookup'
# >>   Judge Load (0.1ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`key` = 'lose' ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/concerns/memory_record_bind.rb:77:in `lookup'
# >>   Swars::Membership Exists? (0.1ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`location_id` = 2 AND `swars_memberships`.`battle_id` IS NULL LIMIT 1
# >>   Swars::Membership Exists? (0.1ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`user_id` = 1011739 AND `swars_memberships`.`battle_id` IS NULL LIMIT 1
# >>   Swars::Membership Exists? (0.1ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`op_user_id` = 1011737 AND `swars_memberships`.`battle_id` IS NULL LIMIT 1
# >>   Swars::Final Load (0.1ms)  SELECT `swars_finals`.* FROM `swars_finals` WHERE `swars_finals`.`id` = 1 ORDER BY `swars_finals`.`position` ASC LIMIT 1
# >>   Swars::Xmode Load (0.1ms)  SELECT `swars_xmodes`.* FROM `swars_xmodes` WHERE `swars_xmodes`.`id` = 1 ORDER BY `swars_xmodes`.`position` ASC LIMIT 1
# >>   Swars::Xmode Load (0.1ms)  SELECT `swars_xmodes`.* FROM `swars_xmodes` WHERE `swars_xmodes`.`key` = '指導' ORDER BY `swars_xmodes`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:36:in `db_record!'
# >>   Swars::Style Load (0.2ms)  SELECT `swars_styles`.* FROM `swars_styles` WHERE `swars_styles`.`key` = '王道' ORDER BY `swars_styles`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:36:in `db_record!'
# >>   Swars::Style Load (0.1ms)  SELECT `swars_styles`.* FROM `swars_styles` WHERE `swars_styles`.`key` = '準王道' ORDER BY `swars_styles`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:36:in `db_record!'
# >>   Swars::Battle Create (1.1ms)  INSERT INTO `swars_battles` (`key`, `battled_at`, `csa_seq`, `win_user_id`, `turn_max`, `meta_info`, `created_at`, `updated_at`, `start_turn`, `critical_turn`, `sfen_body`, `image_turn`, `outbreak_turn`, `accessed_at`, `sfen_hash`, `xmode_id`, `preset_id`, `rule_id`, `final_id`, `analysis_version`) VALUES ('f0b6c3dbe5272a971d59f31e22003288', '2024-11-27 12:49:45', '---\n- - \"+7968GI\"\n  - 600\n- - \"-8232HI\"\n  - 600\n- - \"+5756FU\"\n  - 600\n- - \"-3334FU\"\n  - 600\n- - \"+6857GI\"\n  - 600\n', 1011737, 5, '--- {}\n', '2024-11-27 12:49:45', '2024-11-27 12:49:45', NULL, NULL, 'position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7i6h 8b3b 5g5f 3c3d 6h5g', NULL, NULL, '2024-11-27 12:49:45', '7b7e2206a9d4cdf21d06bc390228ced8', 1, 1, 1, 1, 3)
# >>   Swars::Membership Exists? (0.1ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`location_id` = 1 AND `swars_memberships`.`battle_id` = 54651567 LIMIT 1
# >>   Swars::Membership Exists? (0.2ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`user_id` = 1011737 AND `swars_memberships`.`battle_id` = 54651567 LIMIT 1
# >>   Swars::Membership Exists? (0.1ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`op_user_id` = 1011739 AND `swars_memberships`.`battle_id` = 54651567 LIMIT 1
# >>   Swars::Membership Load (0.3ms)  SELECT `swars_memberships`.* FROM `swars_memberships` WHERE `swars_memberships`.`battle_id` = 54651567 AND (`swars_memberships`.`position` IS NOT NULL) ORDER BY `swars_memberships`.`position` DESC LIMIT 1
# >>   Swars::Membership Create (0.3ms)  INSERT INTO `swars_memberships` (`battle_id`, `user_id`, `grade_id`, `position`, `created_at`, `updated_at`, `grade_diff`, `think_max`, `op_user_id`, `think_last`, `think_all_avg`, `think_end_avg`, `ai_drop_total`, `judge_id`, `location_id`, `style_id`, `ek_score_without_cond`, `ek_score_with_cond`, `ai_wave_count`, `ai_two_freq`, `ai_noizy_two_max`, `ai_gear_freq`, `opponent_id`) VALUES (54651567, 1011737, 39, 0, '2024-11-27 12:49:45', '2024-11-27 12:49:45', 0, 0, 1011739, 0, 0, 0, 0, 1, 1, 1, 0, NULL, 0, 0.0, 0, 0.0, NULL)
# >>   Swars::MembershipExtra Create (0.1ms)  INSERT INTO `swars_membership_extras` (`membership_id`, `used_piece_counts`, `created_at`, `updated_at`) VALUES (108956825, '{\"S0\":2,\"P0\":1}', '2024-11-27 12:49:45.760630', '2024-11-27 12:49:45.760630')
# >>   ActsAsTaggableOn::Tag Load (0.4ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 108956825 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (20.7ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('新嬉野流'))
# >>   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 108956825 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (0.1ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` = 201090 LIMIT 1
# >>   ActsAsTaggableOn::Tagging Exists? (0.2ms)  SELECT 1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 201090 AND `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` = 108956825 AND `taggings`.`context` = 'attack_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ActsAsTaggableOn::Tagging Create (0.2ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `tagger_type`, `tagger_id`, `context`, `created_at`) VALUES (201090, 'Swars::Membership', 108956825, NULL, NULL, 'attack_tags', '2024-11-27 12:49:45')
# >>   ActsAsTaggableOn::Tag Update All (0.2ms)  UPDATE `tags` SET `tags`.`taggings_count` = COALESCE(`tags`.`taggings_count`, 0) + 1 WHERE `tags`.`id` = 201090
# >>   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 108956825 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (26.8ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('対振り飛車') OR LOWER(name) = LOWER('対抗形'))
# >>   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 108956825 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (0.2ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` = 122779 LIMIT 1
# >>   ActsAsTaggableOn::Tagging Exists? (0.4ms)  SELECT 1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 122779 AND `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` = 108956825 AND `taggings`.`context` = 'note_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ActsAsTaggableOn::Tagging Create (0.2ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `tagger_type`, `tagger_id`, `context`, `created_at`) VALUES (122779, 'Swars::Membership', 108956825, NULL, NULL, 'note_tags', '2024-11-27 12:49:45')
# >>   ActsAsTaggableOn::Tag Update All (0.2ms)  UPDATE `tags` SET `tags`.`taggings_count` = COALESCE(`tags`.`taggings_count`, 0) + 1 WHERE `tags`.`id` = 122779
# >>   ActsAsTaggableOn::Tag Load (0.2ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` = 122777 LIMIT 1
# >>   ActsAsTaggableOn::Tagging Exists? (0.4ms)  SELECT 1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 122777 AND `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` = 108956825 AND `taggings`.`context` = 'note_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ActsAsTaggableOn::Tagging Create (0.2ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `tagger_type`, `tagger_id`, `context`, `created_at`) VALUES (122777, 'Swars::Membership', 108956825, NULL, NULL, 'note_tags', '2024-11-27 12:49:45')
# >>   ActsAsTaggableOn::Tag Update All (0.2ms)  UPDATE `tags` SET `tags`.`taggings_count` = COALESCE(`tags`.`taggings_count`, 0) + 1 WHERE `tags`.`id` = 122777
# >>   Swars::Membership Exists? (0.1ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`location_id` = 2 AND `swars_memberships`.`battle_id` = 54651567 LIMIT 1
# >>   Swars::Membership Exists? (0.1ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`user_id` = 1011739 AND `swars_memberships`.`battle_id` = 54651567 LIMIT 1
# >>   Swars::Membership Exists? (0.1ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`op_user_id` = 1011737 AND `swars_memberships`.`battle_id` = 54651567 LIMIT 1
# >>   Swars::Membership Load (0.2ms)  SELECT `swars_memberships`.* FROM `swars_memberships` WHERE `swars_memberships`.`battle_id` = 54651567 AND (`swars_memberships`.`position` IS NOT NULL) ORDER BY `swars_memberships`.`position` DESC LIMIT 1
# >>   Swars::Membership Create (0.3ms)  INSERT INTO `swars_memberships` (`battle_id`, `user_id`, `grade_id`, `position`, `created_at`, `updated_at`, `grade_diff`, `think_max`, `op_user_id`, `think_last`, `think_all_avg`, `think_end_avg`, `ai_drop_total`, `judge_id`, `location_id`, `style_id`, `ek_score_without_cond`, `ek_score_with_cond`, `ai_wave_count`, `ai_two_freq`, `ai_noizy_two_max`, `ai_gear_freq`, `opponent_id`) VALUES (54651567, 1011739, 39, 1, '2024-11-27 12:49:45', '2024-11-27 12:49:45', 0, 0, 1011737, 0, 0, 0, 0, 2, 2, 2, 0, NULL, 0, 0.0, 0, 0.0, NULL)
# >>   Swars::MembershipExtra Create (0.1ms)  INSERT INTO `swars_membership_extras` (`membership_id`, `used_piece_counts`, `created_at`, `updated_at`) VALUES (108956826, '{\"R0\":1,\"P0\":1}', '2024-11-27 12:49:45.837108', '2024-11-27 12:49:45.837108')
# >>   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 108956826 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (20.7ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('2手目△3ニ飛戦法'))
# >>   ActsAsTaggableOn::Tag Load (0.6ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 108956826 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (0.1ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` = 1570 LIMIT 1
# >>   ActsAsTaggableOn::Tagging Exists? (0.3ms)  SELECT 1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 1570 AND `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` = 108956826 AND `taggings`.`context` = 'attack_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ActsAsTaggableOn::Tagging Create (0.3ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `tagger_type`, `tagger_id`, `context`, `created_at`) VALUES (1570, 'Swars::Membership', 108956826, NULL, NULL, 'attack_tags', '2024-11-27 12:49:45')
# >>   ActsAsTaggableOn::Tag Update All (0.2ms)  UPDATE `tags` SET `tags`.`taggings_count` = COALESCE(`tags`.`taggings_count`, 0) + 1 WHERE `tags`.`id` = 1570
# >>   ActsAsTaggableOn::Tag Load (0.2ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 108956826 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (26.7ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('振り飛車') OR LOWER(name) = LOWER('対抗形'))
# >>   ActsAsTaggableOn::Tag Load (0.2ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 108956826 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (0.1ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` = 122776 LIMIT 1
# >>   ActsAsTaggableOn::Tagging Exists? (0.2ms)  SELECT 1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 122776 AND `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` = 108956826 AND `taggings`.`context` = 'note_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ActsAsTaggableOn::Tagging Create (0.2ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `tagger_type`, `tagger_id`, `context`, `created_at`) VALUES (122776, 'Swars::Membership', 108956826, NULL, NULL, 'note_tags', '2024-11-27 12:49:45')
# >>   ActsAsTaggableOn::Tag Update All (0.2ms)  UPDATE `tags` SET `tags`.`taggings_count` = COALESCE(`tags`.`taggings_count`, 0) + 1 WHERE `tags`.`id` = 122776
# >>   ActsAsTaggableOn::Tag Load (0.1ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` = 122777 LIMIT 1
# >>   ActsAsTaggableOn::Tagging Exists? (0.2ms)  SELECT 1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 122777 AND `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` = 108956826 AND `taggings`.`context` = 'note_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ActsAsTaggableOn::Tagging Create (0.1ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `tagger_type`, `tagger_id`, `context`, `created_at`) VALUES (122777, 'Swars::Membership', 108956826, NULL, NULL, 'note_tags', '2024-11-27 12:49:45')
# >>   ActsAsTaggableOn::Tag Update All (0.1ms)  UPDATE `tags` SET `tags`.`taggings_count` = COALESCE(`tags`.`taggings_count`, 0) + 1 WHERE `tags`.`id` = 122777
# >>   Swars::Membership Update (0.2ms)  UPDATE `swars_memberships` SET `swars_memberships`.`opponent_id` = 108956826 WHERE `swars_memberships`.`id` = 108956825
# >>   ↳ app/models/swars/battle/basic_methods.rb:104:in `block (3 levels) in <class:Battle>'
# >>   Swars::Membership Update (0.1ms)  UPDATE `swars_memberships` SET `swars_memberships`.`opponent_id` = 108956825 WHERE `swars_memberships`.`id` = 108956826
# >>   ↳ app/models/swars/battle/basic_methods.rb:105:in `block (3 levels) in <class:Battle>'
# >>   ActsAsTaggableOn::Tagging Load (0.2ms)  SELECT `taggings`.* FROM `taggings` WHERE `taggings`.`taggable_id` = 54651567 AND `taggings`.`taggable_type` = 'Swars::Battle'
# >>   TRANSACTION (0.5ms)  COMMIT
# >>   Swars::User Pluck (0.4ms)  SELECT DISTINCT `swars_users`.`user_key` FROM `swars_users` LEFT OUTER JOIN `swars_grades` ON `swars_grades`.`id` = `swars_users`.`grade_id` LEFT OUTER JOIN `swars_memberships` ON `swars_memberships`.`user_id` = `swars_users`.`id` WHERE `swars_users`.`user_key` = 'af573f28cae329bd938e60b2d3887056'
# >>   ↳ app/models/quick_script/swars/user_group_script.rb:241:in `db_exist_user_keys'
# >>   Swars::User Load (0.2ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`user_key` = 'af573f28cae329bd938e60b2d3887056' ORDER BY FIELD(swars_users.user_key, 'af573f28cae329bd938e60b2d3887056')
# >>   ↳ app/models/quick_script/swars/user_group_script.rb:118:in `collect'
# >>   Swars::Grade Load (0.2ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` = 39 ORDER BY `swars_grades`.`priority` ASC
# >>   ↳ app/models/quick_script/swars/user_group_script.rb:118:in `collect'
# >>   Swars::Membership Load (0.2ms)  SELECT `swars_memberships`.* FROM `swars_memberships` WHERE `swars_memberships`.`user_id` = 1011737
# >>   ↳ app/models/quick_script/swars/user_group_script.rb:118:in `collect'
# >>   Swars::Membership Ids (0.2ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 1011737 ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50
# >>   ↳ app/models/swars/user/stat/scope_ext.rb:31:in `scope_ids'
# >>   Swars::Membership Load (0.3ms)  SELECT swars_rules.key AS rule_key, MIN(swars_grades.priority) AS min_priority FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `swars_rules` ON `swars_rules`.`id` = `swars_battles`.`rule_id` INNER JOIN `swars_grades` ON `swars_grades`.`id` = `swars_memberships`.`grade_id` WHERE `swars_memberships`.`id` IN (108956823, 108956825) GROUP BY `rule_key`
# >>   ↳ app/models/swars/user/stat/grade_by_rules_stat.rb:40:in `block (2 levels) in grades_hash'
# >>   Swars::Membership Count (0.3ms)  SELECT COUNT(*) AS `count_all`, `judges`.`key` AS `judges_key` FROM `swars_memberships` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` WHERE `swars_memberships`.`id` IN (108956823, 108956825) GROUP BY `judges`.`key`
# >>   ↳ app/models/swars/user/stat/membership_global_extension.rb:14:in `total_judge_counts'
# >>   Swars::Membership Count (0.2ms)  SELECT COUNT(*) FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`id` IN (108956823, 108956825) AND `swars_battles`.`battled_at` >= '2024-11-22 12:49:45'
# >>   ↳ app/models/swars/user/stat/vitality_stat.rb:30:in `block in count'
# >>   Swars::Membership Count (0.1ms)  SELECT COUNT(*) FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (108956823, 108956825)
# >>   ↳ app/models/swars/user/stat/scope_ext.rb:41:in `ids_count'
# >>   Swars::Membership Count (0.2ms)  SELECT COUNT(*) AS `count_all`, `swars_xmodes`.`key` AS `swars_xmodes_key`, `judges`.`key` AS `judges_key` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `swars_xmodes` ON `swars_xmodes`.`id` = `swars_battles`.`xmode_id` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` WHERE `swars_memberships`.`id` IN (108956823, 108956825) GROUP BY `swars_xmodes`.`key`, `judges`.`key`
# >>   ↳ app/models/swars/user/stat/xmode_judge_stat.rb:113:in `block in counts_hash'
# >>   Swars::Membership Count (0.4ms)  SELECT COUNT(*) AS `count_all`, `judges`.`key` AS `judges_key`, `swars_finals`.`key` AS `swars_finals_key` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `swars_finals` ON `swars_finals`.`id` = `swars_battles`.`final_id` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` WHERE `swars_memberships`.`id` IN (108956823, 108956825) AND `swars_battles`.`turn_max` >= 2 GROUP BY `judges`.`key`, `swars_finals`.`key`
# >>   ↳ app/models/swars/user/stat/judge_final_stat.rb:66:in `block in counts_hash'
# >>   Swars::Membership Average (0.4ms)  SELECT AVG(turn_max) AS `average_turn_max`, `judges`.`key` AS `judges_key` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` WHERE `swars_memberships`.`id` IN (108956823, 108956825) GROUP BY `judges`.`key`
# >>   ↳ app/models/swars/user/stat/average_moves_by_outcome_stat.rb:30:in `block in averages_hash'
# >>   Swars::Membership Count (0.4ms)  SELECT COUNT(*) AS `count_all`, `tags`.`name` AS `tags_name`, `judges`.`key` AS `judges_key` FROM `swars_memberships` INNER JOIN `taggings` ON `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` = `swars_memberships`.`id` INNER JOIN `tags` ON `tags`.`id` = `taggings`.`tag_id` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` WHERE `swars_memberships`.`id` IN (108956823, 108956825) GROUP BY `tags`.`name`, `judges`.`key`
# >>   ↳ app/models/swars/user/stat/tag_stat.rb:236:in `block in internal_counts_hash'
# >>   Swars::Membership Count (0.2ms)  SELECT COUNT(*) FROM `swars_memberships` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` WHERE `swars_memberships`.`id` IN (108956823, 108956825) AND `judges`.`key` = 'draw'
# >>   ↳ app/models/swars/user/stat/sub_scope_methods.rb:43:in `draw_count'
# >>   Swars::Membership Average (0.1ms)  SELECT AVG(`swars_memberships`.`think_all_avg`) FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (108956823, 108956825)
# >>   ↳ app/models/swars/user/stat/think_stat.rb:44:in `average'
# >>   Swars::Membership Count (0.4ms)  SELECT COUNT(*) FROM `swars_memberships` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `swars_finals` ON `swars_finals`.`id` = `swars_battles`.`final_id` WHERE `swars_memberships`.`id` IN (108956823, 108956825) AND `judges`.`key` = 'lose' AND (`swars_finals`.`key` = 'TORYO' OR `swars_finals`.`key` = 'CHECKMATE') AND `swars_battles`.`turn_max` BETWEEN 14 AND 44
# >>   ↳ app/models/swars/user/stat/lethargy_stat.rb:32:in `block in count'
# >>   Swars::Membership Count (0.3ms)  SELECT COUNT(*) FROM `swars_memberships` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `swars_finals` ON `swars_finals`.`id` = `swars_battles`.`final_id` WHERE `swars_memberships`.`id` IN (108956823, 108956825) AND `judges`.`key` = 'lose' AND (`swars_finals`.`key` = 'TORYO' OR `swars_finals`.`key` = 'CHECKMATE') AND `swars_battles`.`turn_max` < 14
# >>   ↳ app/models/swars/user/stat/skill_adjust_stat.rb:25:in `block in count'
# >>   Swars::Membership Count (1.6ms)  SELECT COUNT(*) FROM `swars_memberships` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `swars_finals` ON `swars_finals`.`id` = `swars_battles`.`final_id` WHERE `swars_memberships`.`id` IN (108956823, 108956825) AND `judges`.`key` = 'win' AND `swars_memberships`.`think_last` >= 45 AND `swars_finals`.`key` = 'CHECKMATE'
# >>   ↳ app/models/swars/user/stat/taunt_mate_stat.rb:42:in `count'
# >>   Swars::Membership Count (0.3ms)  SELECT COUNT(*) FROM `swars_memberships` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `swars_finals` ON `swars_finals`.`id` = `swars_battles`.`final_id` WHERE `swars_memberships`.`id` IN (108956823, 108956825) AND `judges`.`key` = 'win' AND `swars_memberships`.`think_last` >= 45 AND `swars_finals`.`key` = 'TIMEOUT'
# >>   ↳ app/models/swars/user/stat/taunt_mate_stat.rb:42:in `count'
# >>   Swars::Membership Count (0.2ms)  SELECT COUNT(*) FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`id` IN (108956823, 108956825) AND (`swars_memberships`.`ai_wave_count` >= 3 OR `swars_memberships`.`ai_drop_total` >= 15 OR `swars_memberships`.`ai_two_freq` >= 0.6 AND `swars_battles`.`turn_max` >= 50 OR `swars_memberships`.`ai_gear_freq` >= 0.22 AND `swars_battles`.`turn_max` >= 50)
# >>   ↳ app/models/swars/user/stat/fraud_stat.rb:13:in `count'
# >>   Swars::Membership Count (0.4ms)  SELECT COUNT(*) FROM `swars_memberships` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `swars_xmodes` ON `swars_xmodes`.`id` = `swars_battles`.`xmode_id` WHERE `swars_memberships`.`id` IN (108956823, 108956825) AND `judges`.`key` = 'win' AND `swars_xmodes`.`key` = '野良' AND `swars_memberships`.`grade_diff` >= 10
# >>   ↳ app/models/swars/user/stat/gdiff_stat.rb:67:in `block in row_grade_pretend_count'
# >>   Swars::Membership Average (0.1ms)  SELECT AVG(`swars_memberships`.`grade_diff`) FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (108956823, 108956825)
# >>   ↳ app/models/swars/user/stat/gdiff_stat.rb:52:in `average'
# >>   Swars::Membership Count (0.1ms)  SELECT COUNT(*) FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (108956823, 108956825) AND `swars_memberships`.`think_max` >= 180
# >>   ↳ app/models/swars/user/stat/prolonged_deliberation_stat.rb:27:in `block in count'
# >>   Swars::Membership Count (0.2ms)  SELECT COUNT(*) FROM `swars_memberships` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `swars_finals` ON `swars_finals`.`id` = `swars_battles`.`final_id` WHERE `swars_memberships`.`id` IN (108956823, 108956825) AND `judges`.`key` = 'lose' AND `swars_finals`.`key` = 'TIMEOUT' AND `swars_memberships`.`think_last` >= 60
# >>   ↳ app/models/swars/user/stat/leave_alone_stat.rb:49:in `count'
# >>   Swars::Membership Count (0.4ms)  SELECT COUNT(*) FROM `swars_memberships` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`id` IN (108956823, 108956825) AND `judges`.`key` = 'lose' AND `swars_memberships`.`think_last` IS NOT NULL AND `swars_memberships`.`think_max` != `swars_memberships`.`think_last` AND `swars_memberships`.`think_max` >= 300 AND `swars_battles`.`turn_max` >= 14
# >>   ↳ app/models/swars/user/stat/waiting_to_leave_stat.rb:34:in `block in count'
# >>   Swars::Membership Count (0.3ms)  SELECT COUNT(*) FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `swars_finals` ON `swars_finals`.`id` = `swars_battles`.`final_id` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` WHERE `swars_memberships`.`id` IN (108956823, 108956825) AND `swars_battles`.`turn_max` < 2 AND `swars_finals`.`key` = 'DISCONNECT' AND `judges`.`key` = 'lose'
# >>   ↳ app/models/swars/user/stat/unstable_network_stat.rb:28:in `block in count'
# >>   ActsAsTaggableOn::Tag Load (0.4ms)  SELECT tags.*, taggings.tags_count AS count FROM `tags` JOIN (SELECT taggings.tag_id, COUNT(taggings.tag_id) AS tags_count FROM `taggings` WHERE (taggings.taggable_type = 'Swars::Membership' AND taggings.context = 'attack_tags') AND (taggings.taggable_id IN(SELECT `swars_memberships`.`id` FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (108956823, 108956825))) GROUP BY `taggings`.`tag_id` HAVING (COUNT(taggings.tag_id) > 0)) AS taggings ON taggings.tag_id = tags.id ORDER BY count DESC, tags.id ASC LIMIT 1
# >>   ↳ app/models/swars/user/stat/simple_matrix_stat.rb:79:in `find_one'
# >>   ActsAsTaggableOn::Tag Load (0.2ms)  SELECT tags.*, taggings.tags_count AS count FROM `tags` JOIN (SELECT taggings.tag_id, COUNT(taggings.tag_id) AS tags_count FROM `taggings` WHERE (taggings.taggable_type = 'Swars::Membership' AND taggings.context = 'defense_tags') AND (taggings.taggable_id IN(SELECT `swars_memberships`.`id` FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (108956823, 108956825))) GROUP BY `taggings`.`tag_id` HAVING (COUNT(taggings.tag_id) > 0)) AS taggings ON taggings.tag_id = tags.id ORDER BY count DESC, tags.id ASC LIMIT 1
# >>   ↳ app/models/swars/user/stat/simple_matrix_stat.rb:79:in `find_one'
# >> |---------+------------------------------------------------------------------------------------------------------------------------------------------------+------+------+-----+------+-------+------+-------+--------+----------+----------+--------+------------+-----------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------+-----------------|
# >> | 名前    | ウォーズID                                                                                                                                     | 最高 | 10分 | 3分 | 10秒 | 勝率  | 勢い | 規範  | 居飛車 | 振り飛車 | 主戦法   | 主囲い | 直近対局   | リンク1                                                                                                               | リンク2                                                                                                                        | リンク3                                                                                                     | リンク4                                                                                                                    | 最高段位(index) |
# >> |---------+------------------------------------------------------------------------------------------------------------------------------------------------+------+------+-----+------+-------+------+-------+--------+----------+----------+--------+------------+-----------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------+-----------------|
# >> | (xname) | {:_nuxt_link=>{:name=>"af573f28cae329bd938e60b2d3887056", :to=>{:name=>"swars-search", :query=>{:query=>"af573f28cae329bd938e60b2d3887056"}}}} | 30級 | 30級 |     |      | 100 % | 13 % | 60 点 | 0 %    | 0 %      | 新嬉野流 |        | 2024-11-27 | {:_nuxt_link=>{:name=>"棋譜(2)", :to=>{:name=>"swars-search", :query=>{:query=>"af573f28cae329bd938e60b2d3887056"}}}} | {:_nuxt_link=>{:name=>"プレイヤー情報", :to=>{:name=>"swars-users-key", :params=>{:key=>"af573f28cae329bd938e60b2d3887056"}}}} | <a href="https://shogiwars.heroz.jp/users/mypage/af573f28cae329bd938e60b2d3887056" target="_blank">本家</a> | <a href="https://www.google.co.jp/search?q=af573f28cae329bd938e60b2d3887056+%E5%B0%86%E6%A3%8B" target="_blank">ググる</a> |              39 |
# >> |---------+------------------------------------------------------------------------------------------------------------------------------------------------+------+------+-----+------+-------+------+-------+--------+----------+----------+--------+------------+-----------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------+-----------------|
