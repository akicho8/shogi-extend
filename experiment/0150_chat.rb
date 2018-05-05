#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

ChatArticle.destroy_all
ChatUser.destroy_all
ChatRoom.destroy_all
ChatMembership.destroy_all

alice = ChatUser.create!
bob = ChatUser.create!

chat_room = alice.owner_rooms.create!
chat_room.chat_users << alice
chat_room.chat_users << bob

tp chat_room.chat_memberships

alice.chat_articles.create(chat_room: chat_room, message: "(body)")
tp ChatArticle

tp chat_room

alice.update!(current_chat_room: chat_room)
tp chat_room.current_chat_users

# >> |----+--------------+--------------+--------------+----------+------------+---------------------------+---------------------------|
# >> | id | chat_room_id | chat_user_id | location_key | position | standby_at | created_at                | updated_at                |
# >> |----+--------------+--------------+--------------+----------+------------+---------------------------+---------------------------|
# >> |  3 |            5 |            4 | black        |        0 |            | 2018-05-05 19:58:03 +0900 | 2018-05-05 19:58:03 +0900 |
# >> |  4 |            5 |            5 | white        |        1 |            | 2018-05-05 19:58:03 +0900 | 2018-05-05 19:58:03 +0900 |
# >> |----+--------------+--------------+--------------+----------+------------+---------------------------+---------------------------|
# >> |-----+--------------+--------------+---------+---------------------------+---------------------------|
# >> | id  | chat_room_id | chat_user_id | message | created_at                | updated_at                |
# >> |-----+--------------+--------------+---------+---------------------------+---------------------------|
# >> | 209 |            5 |            4 | (body)  | 2018-05-05 19:58:03 +0900 | 2018-05-05 19:58:03 +0900 |
# >> |-----+--------------+--------------+---------+---------------------------+---------------------------|
# >> |--------------------------+-------------------------------------------------------------------------------|
# >> |                       id | 5                                                                             |
# >> |            room_owner_id | 4                                                                             |
# >> |               preset_key | 平手                                                                          |
# >> |             lifetime_key | lifetime5_min                                                                 |
# >> |                     name | 野良1号の対戦部屋 #1                                                          |
# >> |           kifu_body_sfen | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 |
# >> |             clock_counts | {:black=>[], :white=>[]}                                                      |
# >> | current_chat_users_count | 0                                                                             |
# >> |                 turn_max | 0                                                                             |
# >> |          auto_matched_at |                                                                               |
# >> |          battle_begin_at |                                                                               |
# >> |            battle_end_at |                                                                               |
# >> |         win_location_key |                                                                               |
# >> |     give_up_location_key |                                                                               |
# >> |               created_at | 2018-05-05 19:58:03 +0900                                                     |
# >> |               updated_at | 2018-05-05 19:58:03 +0900                                                     |
# >> |--------------------------+-------------------------------------------------------------------------------|
# >> |----+---------+----------------------+--------------+-------------+---------------+------------+---------------------------+---------------------------|
# >> | id | name    | current_chat_room_id | appearing_at | matching_at | lifetime_key  | preset_key | created_at                | updated_at                |
# >> |----+---------+----------------------+--------------+-------------+---------------+------------+---------------------------+---------------------------|
# >> |  4 | 野良1号 |                    5 |              |             | lifetime5_min | 平手       | 2018-05-05 19:58:03 +0900 | 2018-05-05 19:58:03 +0900 |
# >> |----+---------+----------------------+--------------+-------------+---------------+------------+---------------------------+---------------------------|
