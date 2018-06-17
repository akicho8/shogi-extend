#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
Dir.chdir Rails.root

ActiveSupport::LogSubscriber.colorize_logging = false
ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)

free_battle = FreeBattle.create!
free_battle.kifu_file.attach({io: File.open("spec/rails.png"), filename: "rails.png", content_type: "image/png"})
free_battle.kifu_file           # => #<ActiveStorage::Attached::One:0x00007fcaad0370f8 @name="kifu_file", @record=#<FreeBattle id: 31, unique_key: "qKTyHfgjnRnzpFwD5P97QCWw", kifu_url: nil, kifu_body: "", turn_max: 0, meta_info: {:header=>{"手合割"=>"平手"}, :detail_names=>[[], []], :simple_names=>[[], []], :skill_set_hash=>{}}, battled_at: "0000-12-31 15:00:00", created_at: "2018-06-17 13:55:46", updated_at: "2018-06-17 13:55:46", defense_tag_list: nil, attack_tag_list: nil, other_tag_list: nil, secret_tag_list: nil>, @dependent=:purge_later>
free_battle.kifu_file.service_url rescue $! # => #<ArgumentError: Missing host to link to! Please provide the :host parameter, set default_url_options[:host], or set :only_path to true>
free_battle.kifu_file.attached? rescue $! # => true
free_battle.kifu_file.download.size       # => 6646

tp free_battle

# >> ["/Users/ikeda/src/shogi_web/config/initializers/0180_active_model_serializers.rb:11", nil, :ams_sr]
# >>    (0.5ms)  SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci,  @@SESSION.sql_mode = CONCAT(CONCAT(@@sql_mode, ',STRICT_ALL_TABLES'), ',NO_AUTO_VALUE_ON_ZERO'),  @@SESSION.sql_auto_is_null = 0, @@SESSION.wait_timeout = 2147483
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/log_subscriber.rb:98
# >>    (0.3ms)  BEGIN
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/log_subscriber.rb:98
# >>   ActsAsTaggableOn::Tag Update All (0.2ms)  UPDATE `tags` SET `taggings_count` = COALESCE(`taggings_count`, 0) - 1 WHERE 1=0
# >>   ↳ app/models/convert_methods.rb:47
# >>   ActsAsTaggableOn::Tag Update All (0.2ms)  UPDATE `tags` SET `taggings_count` = COALESCE(`taggings_count`, 0) - 1 WHERE 1=0
# >>   ↳ app/models/convert_methods.rb:48
# >>   ActsAsTaggableOn::Tag Update All (0.3ms)  UPDATE `tags` SET `taggings_count` = COALESCE(`taggings_count`, 0) - 1 WHERE 1=0
# >>   ↳ app/models/convert_methods.rb:49
# >>   ActsAsTaggableOn::Tag Update All (0.2ms)  UPDATE `tags` SET `taggings_count` = COALESCE(`taggings_count`, 0) - 1 WHERE 1=0
# >>   ↳ app/models/convert_methods.rb:50
# >>   FreeBattle Create (0.4ms)  INSERT INTO `free_battles` (`unique_key`, `kifu_body`, `turn_max`, `meta_info`, `battled_at`, `created_at`, `updated_at`) VALUES ('qKTyHfgjnRnzpFwD5P97QCWw', '', 0, '---\n:header:\n  手合割: 平手\n:detail_names:\n- []\n- []\n:simple_names:\n- []\n- []\n:skill_set_hash: {}\n', '0000-12-31 15:00:00', '2018-06-17 13:55:46', '2018-06-17 13:55:46')
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/log_subscriber.rb:98
# >>   ConvertedInfo Create (0.3ms)  INSERT INTO `converted_infos` (`convertable_type`, `convertable_id`, `text_body`, `text_format`, `created_at`, `updated_at`) VALUES ('FreeBattle', 31, '手合割：平手\n\nまで0手で後手の勝ち\n', 'ki2', '2018-06-17 13:55:46', '2018-06-17 13:55:46')
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/log_subscriber.rb:98
# >>   ConvertedInfo Create (0.3ms)  INSERT INTO `converted_infos` (`convertable_type`, `convertable_id`, `text_body`, `text_format`, `created_at`, `updated_at`) VALUES ('FreeBattle', 31, '手合割：平手\n手数----指手---------消費時間--\n   1 投了\nまで0手で後手の勝ち\n', 'kif', '2018-06-17 13:55:46', '2018-06-17 13:55:46')
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/log_subscriber.rb:98
# >>   ConvertedInfo Create (0.3ms)  INSERT INTO `converted_infos` (`convertable_type`, `convertable_id`, `text_body`, `text_format`, `created_at`, `updated_at`) VALUES ('FreeBattle', 31, 'V2.2\n\' 手合割:平手\nPI\n+\n\n%TORYO\n', 'csa', '2018-06-17 13:55:46', '2018-06-17 13:55:46')
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/log_subscriber.rb:98
# >>   ConvertedInfo Create (0.3ms)  INSERT INTO `converted_infos` (`convertable_type`, `convertable_id`, `text_body`, `text_format`, `created_at`, `updated_at`) VALUES ('FreeBattle', 31, 'position startpos', 'sfen', '2018-06-17 13:55:46', '2018-06-17 13:55:46')
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/log_subscriber.rb:98
# >>   ActsAsTaggableOn::Tag Load (0.6ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 31 AND `taggings`.`taggable_type` = 'FreeBattle' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/bundler/gems/acts-as-taggable-on-a1d0d30bf5d5/lib/acts_as_taggable_on/taggable/core.rb:240
# >>   ActsAsTaggableOn::Tag Load (0.5ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 31 AND `taggings`.`taggable_type` = 'FreeBattle' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/bundler/gems/acts-as-taggable-on-a1d0d30bf5d5/lib/acts_as_taggable_on/taggable/core.rb:240
# >>   ActsAsTaggableOn::Tag Load (0.5ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('0') OR LOWER(name) = LOWER('平手'))
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/bundler/gems/acts-as-taggable-on-a1d0d30bf5d5/lib/acts_as_taggable_on/tag.rb:78
# >>   ActsAsTaggableOn::Tag Load (0.5ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('0') OR LOWER(name) = LOWER('平手'))
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/bundler/gems/acts-as-taggable-on-a1d0d30bf5d5/lib/acts_as_taggable_on/tag.rb:78
# >>   ActsAsTaggableOn::Tag Load (0.6ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 31 AND `taggings`.`taggable_type` = 'FreeBattle' AND (taggings.context = 'other_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/bundler/gems/acts-as-taggable-on-a1d0d30bf5d5/lib/acts_as_taggable_on/taggable/core.rb:240
# >>   ActsAsTaggableOn::Tag Load (0.4ms)  SELECT  `tags`.* FROM `tags` WHERE `tags`.`id` = 1 LIMIT 1
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/bundler/gems/acts-as-taggable-on-a1d0d30bf5d5/lib/acts_as_taggable_on/taggable/core.rb:269
# >>   ActsAsTaggableOn::Tagging Exists (0.5ms)  SELECT  1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 1 AND `taggings`.`taggable_type` = 'FreeBattle' AND `taggings`.`taggable_id` = 31 AND `taggings`.`context` = 'other_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/bundler/gems/acts-as-taggable-on-a1d0d30bf5d5/lib/acts_as_taggable_on/taggable/core.rb:269
# >>   ActsAsTaggableOn::Tagging Create (0.4ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `context`, `created_at`) VALUES (1, 'FreeBattle', 31, 'other_tags', '2018-06-17 13:55:46')
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/bundler/gems/acts-as-taggable-on-a1d0d30bf5d5/lib/acts_as_taggable_on/taggable/core.rb:269
# >>   ActsAsTaggableOn::Tag Update All (0.4ms)  UPDATE `tags` SET `taggings_count` = COALESCE(`taggings_count`, 0) + 1 WHERE `tags`.`id` = 1
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/bundler/gems/acts-as-taggable-on-a1d0d30bf5d5/lib/acts_as_taggable_on/taggable/core.rb:269
# >>   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT  `tags`.* FROM `tags` WHERE `tags`.`id` = 2 LIMIT 1
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/bundler/gems/acts-as-taggable-on-a1d0d30bf5d5/lib/acts_as_taggable_on/taggable/core.rb:269
# >>   ActsAsTaggableOn::Tagging Exists (0.5ms)  SELECT  1 AS one FROM `taggings` WHERE `taggings`.`tag_id` = 2 AND `taggings`.`taggable_type` = 'FreeBattle' AND `taggings`.`taggable_id` = 31 AND `taggings`.`context` = 'other_tags' AND `taggings`.`tagger_id` IS NULL AND `taggings`.`tagger_type` IS NULL LIMIT 1
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/bundler/gems/acts-as-taggable-on-a1d0d30bf5d5/lib/acts_as_taggable_on/taggable/core.rb:269
# >>   ActsAsTaggableOn::Tagging Create (0.4ms)  INSERT INTO `taggings` (`tag_id`, `taggable_type`, `taggable_id`, `context`, `created_at`) VALUES (2, 'FreeBattle', 31, 'other_tags', '2018-06-17 13:55:46')
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/bundler/gems/acts-as-taggable-on-a1d0d30bf5d5/lib/acts_as_taggable_on/taggable/core.rb:269
# >>   ActsAsTaggableOn::Tag Update All (0.3ms)  UPDATE `tags` SET `taggings_count` = COALESCE(`taggings_count`, 0) + 1 WHERE `tags`.`id` = 2
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/bundler/gems/acts-as-taggable-on-a1d0d30bf5d5/lib/acts_as_taggable_on/taggable/core.rb:269
# >>    (2.0ms)  COMMIT
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/log_subscriber.rb:98
# >>    (0.3ms)  BEGIN
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/log_subscriber.rb:98
# >>   ActiveStorage::Blob Create (0.4ms)  INSERT INTO `active_storage_blobs` (`key`, `filename`, `content_type`, `metadata`, `byte_size`, `checksum`, `created_at`) VALUES ('w6msDpRBsQYTBFrGfaR1NrbN', 'rails.png', 'image/png', '{\"identified\":true}', 6646, 'nAoHm913AdfnKb2VaCPRUw==', '2018-06-17 13:55:46')
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/log_subscriber.rb:98
# >>    (2.6ms)  COMMIT
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/log_subscriber.rb:98
# >>    (0.3ms)  BEGIN
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/log_subscriber.rb:98
# >>   ActiveStorage::Attachment Create (0.5ms)  INSERT INTO `active_storage_attachments` (`name`, `record_type`, `record_id`, `blob_id`, `created_at`) VALUES ('kifu_file', 'FreeBattle', 31, 1, '2018-06-17 13:55:46')
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/log_subscriber.rb:98
# >>   FreeBattle Update (0.4ms)  UPDATE `free_battles` SET `updated_at` = '2018-06-17 13:55:46' WHERE `free_battles`.`id` = 31
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/log_subscriber.rb:98
# >>    (0.5ms)  COMMIT
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/log_subscriber.rb:98
# >>    (1.6ms)  SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci,  @@SESSION.sql_mode = CONCAT(CONCAT(@@sql_mode, ',STRICT_ALL_TABLES'), ',NO_AUTO_VALUE_ON_ZERO'),  @@SESSION.sql_auto_is_null = 0, @@SESSION.wait_timeout = 2147483
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/log_subscriber.rb:98
# >>   ActiveStorage::Blob Load (3.3ms)  SELECT  `active_storage_blobs`.* FROM `active_storage_blobs` WHERE `active_storage_blobs`.`id` = 1 LIMIT 1
# >>   ↳ /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activerecord-5.2.0/lib/active_record/log_subscriber.rb:98
# >> |------------------+------------------------------------------------------------------------------------------------------|
# >> |               id | 31                                                                                                   |
# >> |       unique_key | qKTyHfgjnRnzpFwD5P97QCWw                                                                             |
# >> |         kifu_url |                                                                                                      |
# >> |        kifu_body |                                                                                                      |
# >> |         turn_max | 0                                                                                                    |
# >> |        meta_info | {:header=>{"手合割"=>"平手"}, :detail_names=>[[], []], :simple_names=>[[], []], :skill_set_hash=>{}} |
# >> |       battled_at | 0001-01-01 00:00:00 +0900                                                                            |
# >> |       created_at | 2018-06-17 22:55:46 +0900                                                                            |
# >> |       updated_at | 2018-06-17 22:55:46 +0900                                                                            |
# >> | defense_tag_list |                                                                                                      |
# >> |  attack_tag_list |                                                                                                      |
# >> |   other_tag_list |                                                                                                      |
# >> |  secret_tag_list |                                                                                                      |
# >> |------------------+------------------------------------------------------------------------------------------------------|
