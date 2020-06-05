#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
Dir.chdir Rails.root

ActiveSupport::LogSubscriber.colorize_logging = false
ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)

free_battle = FreeBattle.create!
tp free_battle

# >>    (0.6ms)  SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci,  @@SESSION.sql_mode = CONCAT(CONCAT(@@sql_mode, ',STRICT_ALL_TABLES'), ',NO_AUTO_VALUE_ON_ZERO'),  @@SESSION.sql_auto_is_null = 0, @@SESSION.wait_timeout = 2147483
# >>    (0.4ms)  BEGIN
# >>   ↳ app/models/free_battle.rb:307:in `parser_exec_after'
# >>   FreeBattle Create (0.6ms)  INSERT INTO `free_battles` (`key`, `kifu_body`, `turn_max`, `meta_info`, `battled_at`, `use_key`, `accessed_at`, `created_at`, `updated_at`, `title`, `description`, `saturn_key`, `sfen_body`, `preset_key`, `sfen_hash`) VALUES ('321cfa772ce81f65c4b44130b2616f9d', '', 0, '---\n:black:\n  :defense: []\n  :attack: []\n  :technique: []\n  :note:\n  - :居飛車\n  - :相居飛車\n  - :居玉\n  - :相居玉\n:white:\n  :defense: []\n  :attack: []\n  :technique: []\n  :note:\n  - :居飛車\n  - :相居飛車\n  - :居玉\n  - :相居玉\n', '0000-12-31 14:41:01', 'basic', '2020-06-05 04:44:03', '2020-06-05 04:44:03', '2020-06-05 04:44:03', '', '', 'public', 'position startpos', '平手', 'd3c5be51f1d024db54df870a6ebca2a3')
# >>   ActsAsTaggableOn::Tag Load (0.6ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 3 AND `taggings`.`taggable_type` = 'FreeBattle' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (0.5ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 3 AND `taggings`.`taggable_type` = 'FreeBattle' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (0.5ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 3 AND `taggings`.`taggable_type` = 'FreeBattle' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (0.4ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('居飛車') OR LOWER(name) = LOWER('相居飛車') OR LOWER(name) = LOWER('居玉') OR LOWER(name) = LOWER('相居玉'))
# >>   ActsAsTaggableOn::Tag Load (0.6ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 3 AND `taggings`.`taggable_type` = 'FreeBattle' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ActsAsTaggableOn::Tag Load (0.6ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` = 2 LIMIT 1
# >>   ActsAsTaggableOn::Tagging Exists? (0.5ms)  SELECT 1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 2 AND `taggings`.`taggable_type` = 'FreeBattle' AND `taggings`.`taggable_id` = 3 AND `taggings`.`context` = 'note_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ActsAsTaggableOn::Tagging Create (0.4ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `context`, `created_at`) VALUES (2, 'FreeBattle', 3, 'note_tags', '2020-06-05 04:44:03')
# >>   ActsAsTaggableOn::Tag Update All (0.5ms)  UPDATE `tags` SET `tags`.`taggings_count` = COALESCE(`tags`.`taggings_count`, 0) + 1 WHERE `tags`.`id` = 2
# >>   ActsAsTaggableOn::Tag Load (0.4ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` = 12 LIMIT 1
# >>   ActsAsTaggableOn::Tagging Exists? (0.5ms)  SELECT 1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 12 AND `taggings`.`taggable_type` = 'FreeBattle' AND `taggings`.`taggable_id` = 3 AND `taggings`.`context` = 'note_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ActsAsTaggableOn::Tagging Create (0.4ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `context`, `created_at`) VALUES (12, 'FreeBattle', 3, 'note_tags', '2020-06-05 04:44:03')
# >>   ActsAsTaggableOn::Tag Update All (0.4ms)  UPDATE `tags` SET `tags`.`taggings_count` = COALESCE(`tags`.`taggings_count`, 0) + 1 WHERE `tags`.`id` = 12
# >>   ActsAsTaggableOn::Tag Load (1.0ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` = 3 LIMIT 1
# >>   ActsAsTaggableOn::Tagging Exists? (0.6ms)  SELECT 1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 3 AND `taggings`.`taggable_type` = 'FreeBattle' AND `taggings`.`taggable_id` = 3 AND `taggings`.`context` = 'note_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ActsAsTaggableOn::Tagging Create (0.4ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `context`, `created_at`) VALUES (3, 'FreeBattle', 3, 'note_tags', '2020-06-05 04:44:03')
# >>   ActsAsTaggableOn::Tag Update All (0.4ms)  UPDATE `tags` SET `tags`.`taggings_count` = COALESCE(`tags`.`taggings_count`, 0) + 1 WHERE `tags`.`id` = 3
# >>   ActsAsTaggableOn::Tag Load (0.5ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` = 13 LIMIT 1
# >>   ActsAsTaggableOn::Tagging Exists? (0.8ms)  SELECT 1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 13 AND `taggings`.`taggable_type` = 'FreeBattle' AND `taggings`.`taggable_id` = 3 AND `taggings`.`context` = 'note_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ActsAsTaggableOn::Tagging Create (0.5ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `context`, `created_at`) VALUES (13, 'FreeBattle', 3, 'note_tags', '2020-06-05 04:44:03')
# >>   ActsAsTaggableOn::Tag Update All (0.4ms)  UPDATE `tags` SET `tags`.`taggings_count` = COALESCE(`tags`.`taggings_count`, 0) + 1 WHERE `tags`.`id` = 13
# >>    (1.8ms)  COMMIT
# >> |--------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                 id | 3                                                                                                                                                                                                    |
# >> |                key | 321cfa772ce81f65c4b44130b2616f9d                                                                                                                                                                     |
# >> |           kifu_url |                                                                                                                                                                                                      |
# >> |          kifu_body |                                                                                                                                                                                                      |
# >> |           turn_max | 0                                                                                                                                                                                                    |
# >> |          meta_info | {:black=>{:defense=>[], :attack=>[], :technique=>[], :note=>[:居飛車, :相居飛車, :居玉, :相居玉]}, :white=>{:defense=>[], :attack=>[], :technique=>[], :note=>[:居飛車, :相居飛車, :居玉, :相居玉]}} |
# >> |         battled_at | 0001-01-01 00:00:00 +0918                                                                                                                                                                            |
# >> |      outbreak_turn |                                                                                                                                                                                                      |
# >> |            use_key | basic                                                                                                                                                                                                |
# >> |        accessed_at | 2020-06-05 13:44:03 +0900                                                                                                                                                                            |
# >> |         created_at | 2020-06-05 13:44:03 +0900                                                                                                                                                                            |
# >> |         updated_at | 2020-06-05 13:44:03 +0900                                                                                                                                                                            |
# >> |  colosseum_user_id |                                                                                                                                                                                                      |
# >> |              title |                                                                                                                                                                                                      |
# >> |        description |                                                                                                                                                                                                      |
# >> |         start_turn |                                                                                                                                                                                                      |
# >> |      critical_turn |                                                                                                                                                                                                      |
# >> |         saturn_key | public                                                                                                                                                                                               |
# >> |          sfen_body | position startpos                                                                                                                                                                                    |
# >> |         image_turn |                                                                                                                                                                                                      |
# >> |         preset_key | 平手                                                                                                                                                                                                 |
# >> |          sfen_hash | d3c5be51f1d024db54df870a6ebca2a3                                                                                                                                                                     |
# >> |   defense_tag_list |                                                                                                                                                                                                      |
# >> |    attack_tag_list |                                                                                                                                                                                                      |
# >> | technique_tag_list |                                                                                                                                                                                                      |
# >> |      note_tag_list |                                                                                                                                                                                                      |
# >> |     other_tag_list |                                                                                                                                                                                                      |
# >> |          kifu_file |                                                                                                                                                                                                      |
# >> |--------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
