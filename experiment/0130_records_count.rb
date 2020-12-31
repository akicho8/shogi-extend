#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

tp ActiveRecord::Base.connection.tables.collect { |table| [table, ActiveRecord::Base.connection.select_value("select count(*) from #{table}")] }.to_h

# >> |----------------------------+----|
# >> |             acns1_messages | 0  |
# >> |                acns1_rooms | 3  |
# >> |             actb_bad_marks | 0  |
# >> |    actb_battle_memberships | 0  |
# >> |               actb_battles | 0  |
# >> |            actb_clip_marks | 0  |
# >> |        actb_endpos_answers | 0  |
# >> |             actb_favorites | 0  |
# >> |                actb_finals | 5  |
# >> |               actb_folders | 33 |
# >> |            actb_good_marks | 0  |
# >> |             actb_histories | 0  |
# >> |                actb_judges | 4  |
# >> |              actb_lineages | 7  |
# >> |        actb_lobby_messages | 0  |
# >> |       actb_main_xrecords | 11 |
# >> |         actb_moves_answers | 0  |
# >> |              actb_ox_marks | 3  |
# >> |     actb_question_messages | 0  |
# >> |             actb_questions | 0  |
# >> |      actb_room_memberships | 0  |
# >> |         actb_room_messages | 0  |
# >> |                 actb_rooms | 0  |
# >> |                 actb_rules | 3  |
# >> |       actb_season_xrecords | 11 |
# >> |               actb_seasons | 1  |
# >> |              actb_settings | 11 |
# >> | active_storage_attachments | 0  |
# >> |       active_storage_blobs | 0  |
# >> |                 alert_logs | 0  |
# >> |       ar_internal_metadata | 1  |
# >> |       colosseum_auth_infos | 0  |
# >> |          colosseum_battles | 0  |
# >> |    colosseum_chat_messages | 0  |
# >> |       colosseum_chronicles | 0  |
# >> |   colosseum_lobby_messages | 0  |
# >> |      colosseum_memberships | 0  |
# >> |         colosseum_profiles | 11 |
# >> |            colosseum_rules | 0  |
# >> |            colosseum_users | 11 |
# >> |      colosseum_watch_ships | 0  |
# >> |         cpu_battle_records | 0  |
# >> |               free_battles | 0  |
# >> |          schema_migrations | 46 |
# >> |              swars_battles | 4  |
# >> |               swars_grades | 40 |
# >> |          swars_memberships | 8  |
# >> |          swars_search_logs | 0  |
# >> |                swars_users | 6  |
# >> |                   taggings | 33 |
# >> |                       tags | 11 |
# >> |                tsl_leagues | 2  |
# >> |            tsl_memberships | 56 |
# >> |                  tsl_users | 56 |
# >> |                 time_records | 4  |
# >> |----------------------------+----|
