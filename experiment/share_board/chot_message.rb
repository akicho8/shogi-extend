require File.expand_path('../../../config/environment', __FILE__)
ShareBoard.setup(force: true)

ShareBoard::MessageScope.count  # => 2

login_user = User.create!

user = ShareBoard::User.create!

room = ShareBoard::Room.create!(key: "dev_room")

# chot_message = user.chot_messages.create!(room: room, content: "a")  # => #<ShareBoard::ChotMessage id: 1, room_id: 1, user_id: 1, message_scope_id: 1, content: "a", performed_at: 1702462991374, created_at: "2023-12-13 19:23:11.000000000 +0900", updated_at: "2023-12-13 19:23:11.000000000 +0900", real_user_id: nil, from_connection_id: nil, primary_emoji: nil>
# chot_message = room.chot_messages.create!(user: user, content: "a")  # => #<ShareBoard::ChotMessage id: 2, room_id: 1, user_id: 1, message_scope_id: 1, content: "a", performed_at: 1702462991385, created_at: "2023-12-13 19:23:11.000000000 +0900", updated_at: "2023-12-13 19:23:11.000000000 +0900", real_user_id: nil, from_connection_id: nil, primary_emoji: nil>
# 
# chot_message.user        # => #<ShareBoard::User id: 1, name: "user1", memberships_count: 0, created_at: "2023-12-13 19:23:11.000000000 +0900", updated_at: "2023-12-13 19:23:11.000000000 +0900", chot_messages_count: 2>
# chot_message.room        # => #<ShareBoard::Room id: 1, key: "dev_room", battles_count: 0, created_at: "2023-12-13 19:23:11.000000000 +0900", updated_at: "2023-12-13 19:23:11.000000000 +0900", chot_messages_count: 2>
# 
# chot_message.real_user = login_user
# chot_message.save!
# chot_message.real_user   # => #<User id: 25, key: "8255324e454df7ac390074bfde8fc8de", name: "", user_agent: "", race_key: "human", name_input_at: nil, created_at: "2023-12-13 19:23:11.000000000 +0900", updated_at: "2023-12-13 19:23:11.000000000 +0900", email: "8255324e454df7ac390074bfde8fc8de@localhost", permit_tag_list: nil>
# 
# room.chot_messages_count # => 2
# user.chot_messages_count # => 2
# 
# room.chot_messages       # => #<ActiveRecord::Associations::CollectionProxy [#<ShareBoard::ChotMessage id: 1, room_id: 1, user_id: 1, message_scope_id: 1, content: "a", performed_at: 1702462991374, created_at: "2023-12-13 19:23:11.000000000 +0900", updated_at: "2023-12-13 19:23:11.000000000 +0900", real_user_id: nil, from_connection_id: nil, primary_emoji: nil>, #<ShareBoard::ChotMessage id: 2, room_id: 1, user_id: 1, message_scope_id: 1, content: "a", performed_at: 1702462991385, created_at: "2023-12-13 19:23:11.000000000 +0900", updated_at: "2023-12-13 19:23:11.000000000 +0900", real_user_id: 25, from_connection_id: nil, primary_emoji: nil>]>
# room.chot_users          # => #<ActiveRecord::Associations::CollectionProxy [#<ShareBoard::User id: 1, name: "user1", memberships_count: 0, created_at: "2023-12-13 19:23:11.000000000 +0900", updated_at: "2023-12-13 19:23:11.000000000 +0900", chot_messages_count: 2>, #<ShareBoard::User id: 1, name: "user1", memberships_count: 0, created_at: "2023-12-13 19:23:11.000000000 +0900", updated_at: "2023-12-13 19:23:11.000000000 +0900", chot_messages_count: 2>]>
# 
# chot_message.message_scope_key = :ms_private
# 
# tp chot_message

room.chot_messages_mock_setup(10, user: user)
# room.chot_messages.destroy_all
# 10.times do |i|
#   room.chot_messages.create!(user: user, content: "(#{i})")
# end
room.chot_messages.count        # => 10
tp room.chot_messages

# >> |----+---------+---------+------------------+---------+---------------+---------------------------+---------------------------+--------------+--------------------+---------------|
# >> | id | room_id | user_id | message_scope_id | content | performed_at  | created_at                | updated_at                | real_user_id | from_connection_id | primary_emoji |
# >> |----+---------+---------+------------------+---------+---------------+---------------------------+---------------------------+--------------+--------------------+---------------|
# >> |  1 |       1 |       1 |                1 | (0)     | 1702530007917 | 2023-12-14 14:00:07 +0900 | 2023-12-14 14:00:07 +0900 |              |                    |               |
# >> |  2 |       1 |       1 |                1 | (1)     | 1702530007922 | 2023-12-14 14:00:07 +0900 | 2023-12-14 14:00:07 +0900 |              |                    |               |
# >> |  3 |       1 |       1 |                1 | (2)     | 1702530007927 | 2023-12-14 14:00:07 +0900 | 2023-12-14 14:00:07 +0900 |              |                    |               |
# >> |  4 |       1 |       1 |                1 | (3)     | 1702530007931 | 2023-12-14 14:00:07 +0900 | 2023-12-14 14:00:07 +0900 |              |                    |               |
# >> |  5 |       1 |       1 |                1 | (4)     | 1702530007936 | 2023-12-14 14:00:07 +0900 | 2023-12-14 14:00:07 +0900 |              |                    |               |
# >> |  6 |       1 |       1 |                1 | (5)     | 1702530007940 | 2023-12-14 14:00:07 +0900 | 2023-12-14 14:00:07 +0900 |              |                    |               |
# >> |  7 |       1 |       1 |                1 | (6)     | 1702530007948 | 2023-12-14 14:00:07 +0900 | 2023-12-14 14:00:07 +0900 |              |                    |               |
# >> |  8 |       1 |       1 |                1 | (7)     | 1702530007952 | 2023-12-14 14:00:07 +0900 | 2023-12-14 14:00:07 +0900 |              |                    |               |
# >> |  9 |       1 |       1 |                1 | (8)     | 1702530007955 | 2023-12-14 14:00:07 +0900 | 2023-12-14 14:00:07 +0900 |              |                    |               |
# >> | 10 |       1 |       1 |                1 | (9)     | 1702530007960 | 2023-12-14 14:00:07 +0900 | 2023-12-14 14:00:07 +0900 |              |                    |               |
# >> |----+---------+---------+------------------+---------+---------------+---------------------------+---------------------------+--------------+--------------------+---------------|
