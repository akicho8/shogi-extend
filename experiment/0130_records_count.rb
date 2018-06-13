#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

tp ActiveRecord::Base.connection.tables.collect { |table|
  [table, ActiveRecord::Base.connection.select_value("select count(*) from #{table}")]
}.to_h
# >> |---------------------------------+-----|
# >> |            ar_internal_metadata | 1   |
# >> |                 converted_infos | 188 |
# >> |             free_battle_records | 30  |
# >> |          general_battle_records | 5   |
# >> |            general_battle_ships | 10  |
# >> |            general_battle_users | 10  |
# >> |               schema_migrations | 14  |
# >> |             battle_grades | 39  |
# >> | battle_record_access_logs | 0   |
# >> |            battle_records | 12  |
# >> |              battle_ships | 24  |
# >> |    battle_user_receptions | 2   |
# >> |              battle_users | 14  |
# >> |                        taggings | 469 |
# >> |                            tags | 141 |
# >> |---------------------------------+-----|
