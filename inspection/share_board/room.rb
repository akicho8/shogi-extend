require File.expand_path('../../../config/environment', __FILE__)
ShareBoard.setup(force: true)

ShareBoard::Room.count   # => 0
ShareBoard::Room.create! # => #<ShareBoard::Room id: 8, key: "dev_room", battles_count: 0, created_at: "2023-03-26 18:42:36.000000000 +0900", updated_at: "2023-03-26 18:42:36.000000000 +0900">
tp ShareBoard::Room
# >> |----+----------+---------------+---------------------------+---------------------------|
# >> | id | key      | battles_count | created_at                | updated_at                |
# >> |----+----------+---------------+---------------------------+---------------------------|
# >> |  8 | dev_room |             0 | 2023-03-26 18:42:36 +0900 | 2023-03-26 18:42:36 +0900 |
# >> |----+----------+---------------+---------------------------+---------------------------|
