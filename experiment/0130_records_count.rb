#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

tp ActiveRecord::Base.connection.tables.collect { |table| [table, ActiveRecord::Base.connection.select_value("select count(*) from #{table}")] }.to_h

# >> ["/Users/ikeda/src/shogi_web/config/initializers/0180_active_model_serializers.rb:11", nil, :ams_sr]
# >> |---------------------------------+-----|
# >> |      active_storage_attachments | 0   |
# >> |            active_storage_blobs | 0   |
# >> |            ar_internal_metadata | 1   |
# >> |                    battle_rooms | 50  |
# >> |                   chat_messages | 0   |
# >> |                 converted_infos | 192 |
# >> |             free_battle_records | 33  |
# >> |          general_battle_records | 5   |
# >> |            general_battle_ships | 10  |
# >> |            general_battle_users | 10  |
# >> |                  lobby_messages | 0   |
# >> |                     memberships | 200 |
# >> |               schema_migrations | 11  |
# >> |             swars_battle_grades | 39  |
# >> | swars_battle_record_access_logs | 18  |
# >> |            swars_battle_records | 10  |
# >> |              swars_battle_ships | 20  |
# >> |    swars_battle_user_receptions | 0   |
# >> |              swars_battle_users | 11  |
# >> |                        taggings | 439 |
# >> |                            tags | 124 |
# >> |                           users | 11  |
# >> |               watch_memberships | 0   |
# >> |---------------------------------+-----|
