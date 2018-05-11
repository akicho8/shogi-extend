#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

30.times do
  alice = ChatUser.create!(online_at: Time.current)
  bob = ChatUser.create!(online_at: Time.current)
  [alice, bob].each do |chat_user|
    chat_user.matching_start
  end
end

tp ChatUser

tp ChatRoom
# >> |--------------------------+-------------------------------------------------------------------------------|
# >> |                       id | 32                                                                            |
# >> |            room_owner_id | 72                                                                            |
# >> |               preset_key | 平手                                                                          |
# >> |             lifetime_key | lifetime5_min                                                                 |
# >> |                     name | 野良73号 vs 野良72号                                                          |
# >> |           kifu_body_sfen | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 |
# >> |             clock_counts | {:black=>[], :white=>[]}                                                      |
# >> |                 turn_max | 0                                                                             |
# >> |          auto_matched_at | 2018-05-09 19:48:40 +0900                                                     |
# >> |          battle_begin_at |                                                                               |
# >> |            battle_end_at |                                                                               |
# >> |         win_location_key |                                                                               |
# >> |     give_up_location_key |                                                                               |
# >> |               created_at | 2018-05-09 19:48:40 +0900                                                     |
# >> |               updated_at | 2018-05-09 19:48:40 +0900                                                     |
# >> | current_chat_users_count | 1                                                                             |
# >> | watch_memberships_count | 1                                                                             |
# >> |--------------------------+-------------------------------------------------------------------------------|
