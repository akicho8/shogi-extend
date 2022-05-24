#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
ActiveSupport::LogSubscriber.colorize_logging = false

s = Swars::Battle.all
s = s.limit(2)
s = s.includes(win_user: nil, memberships: {taggings: :tag})
s.each do |e|
  e.memberships.each do |m|
    m.taggings.loaded?          # => true, true, true, true
    m.taggings.find_all { |e| e.context == "note_tags" }.map { |e| e.tag.name } # => ["居飛車", "居玉"], ["指導対局"], ["居飛車", "居玉"], ["指導対局"]
  end
end

# >>    (0.5ms)  SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci,  @@SESSION.sql_mode = CONCAT(CONCAT(@@sql_mode, ',STRICT_ALL_TABLES'), ',NO_AUTO_VALUE_ON_ZERO'),  @@SESSION.sql_auto_is_null = 0, @@SESSION.wait_timeout = 2147483
# >>   ↳ /usr/local/var/rbenv/versions/2.6.1/lib/ruby/gems/2.6.0/gems/activerecord-5.2.3/lib/active_record/log_subscriber.rb:98
# >>   Swars::Battle Load (0.4ms)  SELECT  `swars_battles`.* FROM `swars_battles` LIMIT 2
# >>   ↳ /usr/local/var/rbenv/versions/2.6.1/lib/ruby/gems/2.6.0/gems/activerecord-5.2.3/lib/active_record/log_subscriber.rb:98
# >>   Swars::User Load (0.4ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`id` = 2
# >>   ↳ /usr/local/var/rbenv/versions/2.6.1/lib/ruby/gems/2.6.0/gems/activerecord-5.2.3/lib/active_record/log_subscriber.rb:98
# >>   Swars::Membership Load (0.4ms)  SELECT `swars_memberships`.* FROM `swars_memberships` WHERE `swars_memberships`.`battle_id` IN (1, 2) ORDER BY `swars_memberships`.`position` ASC
# >>   ↳ /usr/local/var/rbenv/versions/2.6.1/lib/ruby/gems/2.6.0/gems/activerecord-5.2.3/lib/active_record/log_subscriber.rb:98
# >>   ActsAsTaggableOn::Tagging Load (0.5ms)  SELECT `taggings`.* FROM `taggings` WHERE `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` IN (1, 3, 2, 4)
# >>   ↳ /usr/local/var/rbenv/versions/2.6.1/lib/ruby/gems/2.6.0/gems/activerecord-5.2.3/lib/active_record/log_subscriber.rb:98
# >>   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` WHERE `tags`.`id` IN (9, 17, 21, 72, 216)
# >>   ↳ /usr/local/var/rbenv/versions/2.6.1/lib/ruby/gems/2.6.0/gems/activerecord-5.2.3/lib/active_record/log_subscriber.rb:98
