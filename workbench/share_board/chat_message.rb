require "#{__dir__}/setup"
ShareBoard.setup(force: true)

ShareBoard::MessageScope.count  # => 2

session_user = User.create!

user = ShareBoard::User.create!

ShareBoard::Room.simple_say
ShareBoard::Room.something_say

room = ShareBoard::Room.fetch("dev_room")
room.receive_and_bc({
                      # "from_connection_id"=>"Ea29TwGfUbD",
                      "from_user_name" => "alice",
                      "session_user_id" => User.bot.id,
                      # "performed_at"=>1702177627002,
                      # "ua_icon_key"=>"mac",
                      # "ac_events_hash"=>{"initialized"=>1},
                      # "debug_mode_p"=>true,
                      "message_scope_key"=>"ms_private",
                      "content"=>"(content)",
                      # "action"=>"message_share",
                    })

chat_message = user.chat_messages.create!(room: room, content: "a")  # => #<ShareBoard::ChatMessage id: 3, room_id: 1, user_id: 1, message_scope_id: 1, content: "a", performed_at: 1754187027302, created_at: "2025-08-03 11:10:27.000000000 +0900", updated_at: "2025-08-03 11:10:27.000000000 +0900", session_user_id: nil, from_connection_id: nil, primary_emoji: nil>
chat_message = room.chat_messages.create!(user: user, content: "a")  # => #<ShareBoard::ChatMessage id: 4, room_id: 1, user_id: 1, message_scope_id: 1, content: "a", performed_at: 1754187027309, created_at: "2025-08-03 11:10:27.000000000 +0900", updated_at: "2025-08-03 11:10:27.000000000 +0900", session_user_id: nil, from_connection_id: nil, primary_emoji: nil>

chat_message.user        # => #<ShareBoard::User id: 1, name: "(name1)", memberships_count: 0, created_at: "2025-08-03 11:10:27.000000000 +0900", updated_at: "2025-08-03 11:10:27.000000000 +0900", chat_messages_count: 2>
chat_message.room        # => #<ShareBoard::Room id: 1, key: "dev_room", battles_count: 0, created_at: "2025-08-03 11:10:27.000000000 +0900", updated_at: "2025-08-03 11:10:27.000000000 +0900", chat_messages_count: 4>

chat_message.session_user = session_user
chat_message.save!
chat_message.session_user   # => #<User id: 125, key: "920a8cdfb32577283ffa93702b91c7ee", name: "", race_key: "human", name_input_at: nil, created_at: "2025-08-03 11:10:27.000000000 +0900", updated_at: "2025-08-03 11:10:27.000000000 +0900", email: "920a8cdfb32577283ffa93702b91c7ee@localhost", permit_tag_list: nil>

room.chat_messages_count # => 4
user.chat_messages_count # => 2

room.chat_messages       # => #<ActiveRecord::Associations::CollectionProxy [#<ShareBoard::ChatMessage id: 1, room_id: 1, user_id: 2, message_scope_id: 1, content: "", performed_at: 1754187027202, created_at: "2025-08-03 11:10:27.000000000 +0900", updated_at: "2025-08-03 11:10:27.000000000 +0900", session_user_id: nil, from_connection_id: nil, primary_emoji: nil>, #<ShareBoard::ChatMessage id: 2, room_id: 1, user_id: 3, message_scope_id: 2, content: "(content)", performed_at: 1754187027258, created_at: "2025-08-03 11:10:27.000000000 +0900", updated_at: "2025-08-03 11:10:27.000000000 +0900", session_user_id: 2, from_connection_id: nil, primary_emoji: nil>, #<ShareBoard::ChatMessage id: 3, room_id: 1, user_id: 1, message_scope_id: 1, content: "a", performed_at: 1754187027302, created_at: "2025-08-03 11:10:27.000000000 +0900", updated_at: "2025-08-03 11:10:27.000000000 +0900", session_user_id: nil, from_connection_id: nil, primary_emoji: nil>, #<ShareBoard::ChatMessage id: 4, room_id: 1, user_id: 1, message_scope_id: 1, content: "a", performed_at: 1754187027309, created_at: "2025-08-03 11:10:27.000000000 +0900", updated_at: "2025-08-03 11:10:27.000000000 +0900", session_user_id: 125, from_connection_id: nil, primary_emoji: nil>]>
room.chat_users          # => #<ActiveRecord::Associations::CollectionProxy [#<ShareBoard::User id: 1, name: "(name1)", memberships_count: 0, created_at: "2025-08-03 11:10:27.000000000 +0900", updated_at: "2025-08-03 11:10:27.000000000 +0900", chat_messages_count: 2>, #<ShareBoard::User id: 1, name: "(name1)", memberships_count: 0, created_at: "2025-08-03 11:10:27.000000000 +0900", updated_at: "2025-08-03 11:10:27.000000000 +0900", chat_messages_count: 2>, #<ShareBoard::User id: 2, name: "(name2)", memberships_count: 0, created_at: "2025-08-03 11:10:27.000000000 +0900", updated_at: "2025-08-03 11:10:27.000000000 +0900", chat_messages_count: 1>, #<ShareBoard::User id: 3, name: "alice", memberships_count: 0, created_at: "2025-08-03 11:10:27.000000000 +0900", updated_at: "2025-08-03 11:10:27.000000000 +0900", chat_messages_count: 1>]>

chat_message.message_scope_key = :ms_private

tp chat_message

room.setup_for_test(count: 10, user: user)
room.chat_messages.count        # => 4
tp room.chat_messages

# >> 2025-08-03T02:10:27.246Z pid=72407 tid=1icn INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> |--------------------+---------------------------|
# >> |           room_key | dev_room                  |
# >> |  session_user_name |                           |
# >> |                 id | 1                         |
# >> |            room_id | 1                         |
# >> |            user_id | 2                         |
# >> |   message_scope_id | 1                         |
# >> |            content |                           |
# >> |       performed_at | 1754187027202             |
# >> |         created_at | 2025-08-03 11:10:27 +0900 |
# >> |         updated_at | 2025-08-03 11:10:27 +0900 |
# >> |    session_user_id |                           |
# >> | from_connection_id |                           |
# >> |      primary_emoji |                           |
# >> |  message_scope_key | ms_public                 |
# >> |     from_user_name | (name2)                   |
# >> |   from_avatar_path |                           |
# >> |--------------------+---------------------------|
# >> |--------------------+-----------------------------------------------------------------------------------------------|
# >> |           room_key | dev_room                                                                                      |
# >> |  session_user_name | BOT                                                                                           |
# >> |                 id | 2                                                                                             |
# >> |            room_id | 1                                                                                             |
# >> |            user_id | 3                                                                                             |
# >> |   message_scope_id | 2                                                                                             |
# >> |            content | (content)                                                                                     |
# >> |       performed_at | 1754187027258                                                                                 |
# >> |         created_at | 2025-08-03 11:10:27 +0900                                                                     |
# >> |         updated_at | 2025-08-03 11:10:27 +0900                                                                     |
# >> |    session_user_id | 2                                                                                             |
# >> | from_connection_id |                                                                                               |
# >> |      primary_emoji |                                                                                               |
# >> |  message_scope_key | ms_private                                                                                    |
# >> |     from_user_name | alice                                                                                         |
# >> |   from_avatar_path | /assets/robot/0120_robot-a9b2e9e5c44a32bae79cf589b2357952f2135c473a698036181a0d9ba73aff51.png |
# >> |--------------------+-----------------------------------------------------------------------------------------------|
# >> |--------------------+---------------------------|
# >> |                 id | 4                         |
# >> |            room_id | 1                         |
# >> |            user_id | 1                         |
# >> |   message_scope_id | 2                         |
# >> |            content | a                         |
# >> |       performed_at | 1754187027309             |
# >> |         created_at | 2025-08-03 11:10:27 +0900 |
# >> |         updated_at | 2025-08-03 11:10:27 +0900 |
# >> |    session_user_id | 125                       |
# >> | from_connection_id |                           |
# >> |      primary_emoji |                           |
# >> |--------------------+---------------------------|
# >> |----+---------+---------+------------------+-----------+---------------+---------------------------+---------------------------+-----------------+--------------------+---------------|
# >> | id | room_id | user_id | message_scope_id | content   | performed_at  | created_at                | updated_at                | session_user_id | from_connection_id | primary_emoji |
# >> |----+---------+---------+------------------+-----------+---------------+---------------------------+---------------------------+-----------------+--------------------+---------------|
# >> |  1 |       1 |       2 |                1 |           | 1754187027202 | 2025-08-03 11:10:27 +0900 | 2025-08-03 11:10:27 +0900 |                 |                    |               |
# >> |  2 |       1 |       3 |                2 | (content) | 1754187027258 | 2025-08-03 11:10:27 +0900 | 2025-08-03 11:10:27 +0900 |               2 |                    |               |
# >> |  3 |       1 |       1 |                1 | a         | 1754187027302 | 2025-08-03 11:10:27 +0900 | 2025-08-03 11:10:27 +0900 |                 |                    |               |
# >> |  4 |       1 |       1 |                2 | a         | 1754187027309 | 2025-08-03 11:10:27 +0900 | 2025-08-03 11:10:27 +0900 |             125 |                    |               |
# >> |----+---------+---------+------------------+-----------+---------------+---------------------------+---------------------------+-----------------+--------------------+---------------|
