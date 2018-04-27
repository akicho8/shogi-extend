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

# >> nil
# >> nil
# >> |----+--------------+--------------+--------------+----------+---------------------------+---------------------------|
# >> | id | chat_room_id | chat_user_id | location_key | position | created_at                | updated_at                |
# >> |----+--------------+--------------+--------------+----------+---------------------------+---------------------------|
# >> | 13 |           15 |           30 | black        |        0 | 2018-04-27 17:17:39 +0900 | 2018-04-27 17:17:39 +0900 |
# >> | 14 |           15 |           31 | white        |        1 | 2018-04-27 17:17:39 +0900 | 2018-04-27 17:17:39 +0900 |
# >> |----+--------------+--------------+--------------+----------+---------------------------+---------------------------|
# >> |-----+--------------+--------------+---------+---------------------------+---------------------------|
# >> | id  | chat_room_id | chat_user_id | message | created_at                | updated_at                |
# >> |-----+--------------+--------------+---------+---------------------------+---------------------------|
# >> | 138 |           15 |           30 | (body)  | 2018-04-27 17:17:39 +0900 | 2018-04-27 17:17:39 +0900 |
# >> |-----+--------------+--------------+---------+---------------------------+---------------------------|
