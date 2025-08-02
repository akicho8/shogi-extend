require "#{__dir__}/setup"
room = ShareBoard::Room.mock
room.id                         # => 2
user = ShareBoard::User.first # => #<ShareBoard::User id: 1, name: "alice", memberships_count: 2, created_at: "2025-08-02 09:59:54.000000000 +0900", updated_at: "2025-08-02 10:02:01.000000000 +0900", chat_messages_count: 0>
user.room_ids # => [1, 2]

