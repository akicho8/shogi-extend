#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

module Fanta
  tp Battle.last
end
# >> |-------------------+--------------------------------|
# >> |                id | 64                             |
# >> |  black_preset_key | 平手                           |
# >> |  white_preset_key | 平手                           |
# >> |      lifetime_key | lifetime_m5                    |
# >> |       platoon_key | platoon_p1vs1                  |
# >> |         full_sfen | position startpos moves 2h4h   |
# >> |      clock_counts | {:black=>[1], :white=>[]}      |
# >> |   countdown_flags | {:black=>false, :white=>false} |
# >> |          turn_max | 1                              |
# >> | battle_request_at | 2018-07-05 18:11:05 +0900      |
# >> |   auto_matched_at |                                |
# >> |          begin_at | 2018-07-05 18:11:07 +0900      |
# >> |            end_at |                                |
# >> |   last_action_key |                                |
# >> |  win_location_key |                                |
# >> | memberships_count | 2                              |
# >> | watch_ships_count | 0                              |
# >> |        created_at | 2018-07-05 18:11:05 +0900      |
# >> |        updated_at | 2018-07-05 18:11:08 +0900      |
# >> |-------------------+--------------------------------|
