require "#{__dir__}/setup"
ShareBoard.setup(force: true)

tp ShareBoard::Room.mock
tp ShareBoard::Room.create!
tp ShareBoard::Room.create!

# >> |---------------------+---------------------------|
# >> |                  id | 1                         |
# >> |                 key | dev_room1                 |
# >> |       battles_count | 1                         |
# >> |          created_at | 2026-05-02 07:48:47 +0900 |
# >> |          updated_at | 2026-05-02 07:48:48 +0900 |
# >> | chat_messages_count | 0                         |
# >> |                name | (room.name)               |
# >> |---------------------+---------------------------|
# >> |---------------------+---------------------------|
# >> |                  id | 2                         |
# >> |                 key | dev_room2                 |
# >> |       battles_count | 0                         |
# >> |          created_at | 2026-05-02 07:48:48 +0900 |
# >> |          updated_at | 2026-05-02 07:48:48 +0900 |
# >> | chat_messages_count | 0                         |
# >> |                name | 共有将棋盤                |
# >> |---------------------+---------------------------|
# >> |---------------------+---------------------------|
# >> |                  id | 3                         |
# >> |                 key | dev_room3                 |
# >> |       battles_count | 0                         |
# >> |          created_at | 2026-05-02 07:48:48 +0900 |
# >> |          updated_at | 2026-05-02 07:48:48 +0900 |
# >> | chat_messages_count | 0                         |
# >> |                name | 共有将棋盤                |
# >> |---------------------+---------------------------|
