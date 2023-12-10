require File.expand_path('../../../config/environment', __FILE__)
ShareBoard.setup(force: true)

ShareBoard::MessageScope.count  # => 2

login_user = User.create!

user = ShareBoard::User.create!

room = ShareBoard::Room.create!(key: "dev_room")

chot_message = user.chot_messages.create!(room: room, content: "a")  # => #<ShareBoard::ChotMessage id: 1, room_id: 1, user_id: 1, message_scope_id: 1, content: "a", performed_at: 1702198688249, created_at: "2023-12-10 17:58:08.000000000 +0900", updated_at: "2023-12-10 17:58:08.000000000 +0900", real_user_id: nil, from_connection_id: nil, primary_emoji: nil>
chot_message = room.chot_messages.create!(user: user, content: "a")  # => #<ShareBoard::ChotMessage id: 2, room_id: 1, user_id: 1, message_scope_id: 1, content: "a", performed_at: 1702198688257, created_at: "2023-12-10 17:58:08.000000000 +0900", updated_at: "2023-12-10 17:58:08.000000000 +0900", real_user_id: nil, from_connection_id: nil, primary_emoji: nil>

chot_message.user        # => #<ShareBoard::User id: 1, name: "user1", memberships_count: 0, created_at: "2023-12-10 17:58:08.000000000 +0900", updated_at: "2023-12-10 17:58:08.000000000 +0900", chot_messages_count: 2>
chot_message.room        # => #<ShareBoard::Room id: 1, key: "dev_room", battles_count: 0, created_at: "2023-12-10 17:58:08.000000000 +0900", updated_at: "2023-12-10 17:58:08.000000000 +0900", chot_messages_count: 2>

chot_message.real_user = login_user
chot_message.save!
chot_message.real_user   # => #<User id: 20, key: "31e76ce86e11b7204dacc3fbe9bb821f", name: "", user_agent: "", race_key: "human", name_input_at: nil, created_at: "2023-12-10 17:58:08.000000000 +0900", updated_at: "2023-12-10 17:58:08.000000000 +0900", email: "31e76ce86e11b7204dacc3fbe9bb821f@localhost", permit_tag_list: nil>

room.chot_messages_count # => 2
user.chot_messages_count # => 2

room.chot_messages       # => #<ActiveRecord::Associations::CollectionProxy [#<ShareBoard::ChotMessage id: 1, room_id: 1, user_id: 1, message_scope_id: 1, content: "a", performed_at: 1702198688249, created_at: "2023-12-10 17:58:08.000000000 +0900", updated_at: "2023-12-10 17:58:08.000000000 +0900", real_user_id: nil, from_connection_id: nil, primary_emoji: nil>, #<ShareBoard::ChotMessage id: 2, room_id: 1, user_id: 1, message_scope_id: 1, content: "a", performed_at: 1702198688257, created_at: "2023-12-10 17:58:08.000000000 +0900", updated_at: "2023-12-10 17:58:08.000000000 +0900", real_user_id: 20, from_connection_id: nil, primary_emoji: nil>]>
room.chot_users          # => #<ActiveRecord::Associations::CollectionProxy [#<ShareBoard::User id: 1, name: "user1", memberships_count: 0, created_at: "2023-12-10 17:58:08.000000000 +0900", updated_at: "2023-12-10 17:58:08.000000000 +0900", chot_messages_count: 2>, #<ShareBoard::User id: 1, name: "user1", memberships_count: 0, created_at: "2023-12-10 17:58:08.000000000 +0900", updated_at: "2023-12-10 17:58:08.000000000 +0900", chot_messages_count: 2>]>

chot_message.message_scope_key = :is_message_scope_private

tp chot_message

10.times do |i|
  room.chot_messages.create!(user: user, content: "a#{i}")
end

# >> |--------------------+---------------------------|
# >> |                 id | 2                         |
# >> |            room_id | 1                         |
# >> |            user_id | 1                         |
# >> |   message_scope_id | 2                         |
# >> |            content | a                         |
# >> |       performed_at | 1702198688257             |
# >> |         created_at | 2023-12-10 17:58:08 +0900 |
# >> |         updated_at | 2023-12-10 17:58:08 +0900 |
# >> |       real_user_id | 20                        |
# >> | from_connection_id |                           |
# >> |      primary_emoji |                           |
# >> |--------------------+---------------------------|
