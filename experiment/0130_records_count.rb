#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

tp ActiveRecord::Base.connection.tables.collect { |table|
  [table, ActiveRecord::Base.connection.select_value("select count(*) from #{table}")]
}.to_h
# >> |------------------------+-----|
# >> |   ar_internal_metadata | 1   |
# >> |        general_battle_records | 5   |
# >> |          general_battle_ships | 10  |
# >> |          general_battle_users | 12  |
# >> |          battle_grades | 39  |
# >> |         battle_records | 0   |
# >> |           battle_ships | 0   |
# >> | battle_user_receptions | 0   |
# >> |           battle_users | 0   |
# >> |        converted_infos | 140 |
# >> |    free_battle_records | 30  |
# >> |      schema_migrations | 14  |
# >> |               taggings | 167 |
# >> |                   tags | 86  |
# >> |------------------------+-----|
