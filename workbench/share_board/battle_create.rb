require "#{__dir__}/setup"
ShareBoard.setup(force: true)

params = {
  :room_key  => "dev_room",
  :title     => "共有将棋盤",
  :sfen      => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1",
  :turn      => 0,
  :win_location_key => :black,
  :memberships => [
    { :user_name => "a", :location_key => "black", :judge_key => "lose", },
    { :user_name => "b", :location_key => "white", :judge_key => "win",  },
    { :user_name => "c", :location_key => "black", :judge_key => "lose", },
    { :user_name => "d", :location_key => "white", :judge_key => "win",  },
  ],
}

battle_create = ShareBoard::BattleCreate.new(params)
battle_create.call
tp battle_create.battle.room
tp battle_create.battle
tp battle_create.battle.memberships
tp battle_create.battle.room.users

battle = battle_create.battle   # => #<ShareBoard::Battle id: 1, room_id: 1, key: "1c60ad26150227729eb4b4641251e56a", title: "共有将棋盤", sfen: "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPP...", turn: 0, win_location_id: 1, position: 0, created_at: "2025-12-24 18:55:29.000000000 +0900", updated_at: "2025-12-24 18:55:29.000000000 +0900">
room = battle.room              # => #<ShareBoard::Room id: 1, key: "dev_room", battles_count: 1, created_at: "2025-12-24 18:55:29.000000000 +0900", updated_at: "2025-12-24 18:55:29.000000000 +0900", chat_messages_count: 0, name: "共有将棋盤">
battle.memberships.each do |membership|
  membership.user.name          # => "a", "b", "c", "d"
  roomship = room.roomships.find_by(user: membership.user) # => #<ShareBoard::Roomship id: 1, room_id: 1, user_id: 1, win_count: 0, lose_count: 1, battles_count: 1, win_rate: 0.0, score: 0, rank: -1, created_at: "2025-12-24 18:55:29.000000000 +0900", updated_at: "2025-12-24 18:55:29.000000000 +0900">, #<ShareBoard::Roomship id: 2, room_id: 1, user_id: 2, win_count: 1, lose_count: 0, battles_count: 1, win_rate: 1.0, score: 1, rank: -1, created_at: "2025-12-24 18:55:29.000000000 +0900", updated_at: "2025-12-24 18:55:29.000000000 +0900">, #<ShareBoard::Roomship id: 3, room_id: 1, user_id: 3, win_count: 0, lose_count: 1, battles_count: 1, win_rate: 0.0, score: 0, rank: -1, created_at: "2025-12-24 18:55:29.000000000 +0900", updated_at: "2025-12-24 18:55:29.000000000 +0900">, #<ShareBoard::Roomship id: 4, room_id: 1, user_id: 4, win_count: 1, lose_count: 0, battles_count: 1, win_rate: 1.0, score: 1, rank: -1, created_at: "2025-12-24 18:55:30.000000000 +0900", updated_at: "2025-12-24 18:55:30.000000000 +0900">
  roomship.win_count                                       # => 0, 1, 0, 1
end

# >> |---------------------+---------------------------|
# >> |                  id | 1                         |
# >> |                 key | dev_room                  |
# >> |       battles_count | 1                         |
# >> |          created_at | 2025-12-24 18:55:29 +0900 |
# >> |          updated_at | 2025-12-24 18:55:29 +0900 |
# >> | chat_messages_count | 0                         |
# >> |                name | 共有将棋盤                |
# >> |---------------------+---------------------------|
# >> |-----------------+-------------------------------------------------------------------------------|
# >> |              id | 1                                                                             |
# >> |         room_id | 1                                                                             |
# >> |             key | 1c60ad26150227729eb4b4641251e56a                                              |
# >> |           title | 共有将棋盤                                                                    |
# >> |            sfen | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 |
# >> |            turn | 0                                                                             |
# >> | win_location_id | 1                                                                             |
# >> |        position | 0                                                                             |
# >> |      created_at | 2025-12-24 18:55:29 +0900                                                     |
# >> |      updated_at | 2025-12-24 18:55:29 +0900                                                     |
# >> |-----------------+-------------------------------------------------------------------------------|
# >> |----+-----------+---------+----------+-------------+----------+---------------------------+---------------------------|
# >> | id | battle_id | user_id | judge_id | location_id | position | created_at                | updated_at                |
# >> |----+-----------+---------+----------+-------------+----------+---------------------------+---------------------------|
# >> |  1 |         1 |       1 |        2 |           1 |        0 | 2025-12-24 18:55:29 +0900 | 2025-12-24 18:55:29 +0900 |
# >> |  2 |         1 |       2 |        1 |           2 |        1 | 2025-12-24 18:55:29 +0900 | 2025-12-24 18:55:29 +0900 |
# >> |  3 |         1 |       3 |        2 |           1 |        2 | 2025-12-24 18:55:29 +0900 | 2025-12-24 18:55:29 +0900 |
# >> |  4 |         1 |       4 |        1 |           2 |        3 | 2025-12-24 18:55:30 +0900 | 2025-12-24 18:55:30 +0900 |
# >> |----+-----------+---------+----------+-------------+----------+---------------------------+---------------------------|
# >> |----+------+-------------------+---------------------------+---------------------------+---------------------|
# >> | id | name | memberships_count | created_at                | updated_at                | chat_messages_count |
# >> |----+------+-------------------+---------------------------+---------------------------+---------------------|
# >> |  1 | a    |                 1 | 2025-12-24 18:55:29 +0900 | 2025-12-24 18:55:29 +0900 |                   0 |
# >> |  2 | b    |                 1 | 2025-12-24 18:55:29 +0900 | 2025-12-24 18:55:29 +0900 |                   0 |
# >> |  3 | c    |                 1 | 2025-12-24 18:55:29 +0900 | 2025-12-24 18:55:29 +0900 |                   0 |
# >> |  4 | d    |                 1 | 2025-12-24 18:55:29 +0900 | 2025-12-24 18:55:30 +0900 |                   0 |
# >> |----+------+-------------------+---------------------------+---------------------------+---------------------|
