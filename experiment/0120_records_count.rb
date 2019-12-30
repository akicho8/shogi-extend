#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

tp ActiveRecord::Base.connection.tables.collect { |table| [table, ActiveRecord::Base.connection.select_value("select count(*) from #{table}")] }.to_h

# >> |----------------------------+------|
# >> | active_storage_attachments | 0    |
# >> |       active_storage_blobs | 0    |
# >> |       ar_internal_metadata | 1    |
# >> |       colosseum_auth_infos | 0    |
# >> |          colosseum_battles | 50   |
# >> |    colosseum_chat_messages | 1    |
# >> |       colosseum_chronicles | 0    |
# >> |   colosseum_lobby_messages | 1    |
# >> |      colosseum_memberships | 200  |
# >> |         colosseum_profiles | 12   |
# >> |            colosseum_rules | 12   |
# >> |            colosseum_users | 12   |
# >> |      colosseum_watch_ships | 100  |
# >> |            converted_infos | 0    |
# >> |         cpu_battle_records | 1    |
# >> |               free_battles | 576  |
# >> |          schema_migrations | 34   |
# >> |          swars_access_logs | 0    |
# >> |              swars_battles | 21   |
# >> |               swars_grades | 40   |
# >> |          swars_memberships | 42   |
# >> |          swars_search_logs | 11   |
# >> |                swars_users | 33   |
# >> |                   taggings | 3680 |
# >> |                       tags | 233  |
# >> |                 xy_records | 4    |
# >> |----------------------------+------|
