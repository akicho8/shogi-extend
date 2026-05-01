require "#{__dir__}/setup"
ShareBoard.setup(force: true)

# params = {
#   :room_key  => "dev_room",
#   :sfen      => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1",
#   :turn      => 0,
#   :win_location_key => nil,
#   :memberships => [
#     { :user_name => "a", :location_key => "black", :judge_key => "draw", },
#     { :user_name => "b", :location_key => "white", :judge_key => "draw", },
#   ],
# }
# battle_create = ShareBoard::BattleCreate.new(params)
# battle_create.call
# battle = battle_create.battle
# battle.room.roomships.collect(&:rank) # => [3, 3]


params = {
  :room_key  => "dev_room",
  :title     => "共有将棋盤",
  :sfen      => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1",
  :turn      => 0,
  # :win_location_key => :black,
  :memberships => [
    { :user_name => "a", :location_key => "black", :judge_key => "lose", },
    { :user_name => "b", :location_key => "white", :judge_key => "win",  },
    { :user_name => "c", :location_key => "black", :judge_key => "lose", },
    { :user_name => "d", :location_key => "white", :judge_key => "win",  },
    # { :user_name => "a", :location_key => "black", :judge_key => "draw", },
    # { :user_name => "b", :location_key => "white", :judge_key => "draw", },
    # { :user_name => "c", :location_key => "black", :judge_key => "draw", },
    # { :user_name => "d", :location_key => "white", :judge_key => "draw", },
  ],
}

battle_create = ShareBoard::BattleCreate.new(params)
battle_create.call
battle = battle_create.battle.reload
tp battle
tp battle.room
tp battle.memberships
tp battle.room.users
tp battle.room.roomships

# battle = battle_create.battle   # => #<ShareBoard::Battle id: 1, room_id: 1, key: "644c73d385fe57783b9e397cb39a8f36", title: "共有将棋盤", sfen: "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPP...", turn: 0, win_location_id: nil, position: 0, created_at: "2026-04-30 19:38:32.000000000 +0900", updated_at: "2026-04-30 19:38:32.000000000 +0900">
# room = battle.room              # => #<ShareBoard::Room id: 1, key: "dev_room", battles_count: 1, created_at: "2026-04-30 19:38:32.000000000 +0900", updated_at: "2026-04-30 19:38:32.000000000 +0900", chat_messages_count: 0, name: "共有将棋盤">
# battle.memberships.each do |membership|
#   membership.user.name          # => "a", "b", "c", "d"
#   roomship = room.roomships.find_by(user: membership.user) # => #<ShareBoard::Roomship id: 1, room_id: 1, user_id: 1, win_count: 0, lose_count: 0, battles_count: 1, win_rate: 0.0, score: 0, rank: -1, created_at: "2026-04-30 19:38:32.000000000 +0900", updated_at: "2026-04-30 19:38:32.000000000 +0900", draw_count: 1>, #<ShareBoard::Roomship id: 2, room_id: 1, user_id: 2, win_count: 0, lose_count: 0, battles_count: 1, win_rate: 0.0, score: 0, rank: -1, created_at: "2026-04-30 19:38:32.000000000 +0900", updated_at: "2026-04-30 19:38:32.000000000 +0900", draw_count: 1>, #<ShareBoard::Roomship id: 3, room_id: 1, user_id: 3, win_count: 0, lose_count: 0, battles_count: 1, win_rate: 0.0, score: 0, rank: -1, created_at: "2026-04-30 19:38:32.000000000 +0900", updated_at: "2026-04-30 19:38:32.000000000 +0900", draw_count: 1>, #<ShareBoard::Roomship id: 4, room_id: 1, user_id: 4, win_count: 0, lose_count: 0, battles_count: 1, win_rate: 0.0, score: 0, rank: -1, created_at: "2026-04-30 19:38:33.000000000 +0900", updated_at: "2026-04-30 19:38:33.000000000 +0900", draw_count: 1>
#   roomship.win_count                                       # => 0, 0, 0, 0
# end
# >> |-----------------+-------------------------------------------------------------------------------|
# >> |              id | 1                                                                             |
# >> |         room_id | 1                                                                             |
# >> |             key | 846cfb6e43c1ad10da23b92fb46f359c                                              |
# >> |           title | 共有将棋盤                                                                    |
# >> |            sfen | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 |
# >> |            turn | 0                                                                             |
# >> | win_location_id |                                                                               |
# >> |        position | 0                                                                             |
# >> |      created_at | 2026-05-02 07:29:04 +0900                                                     |
# >> |      updated_at | 2026-05-02 07:29:04 +0900                                                     |
# >> |-----------------+-------------------------------------------------------------------------------|
# >> |---------------------+---------------------------|
# >> |                  id | 1                         |
# >> |                 key | dev_room                  |
# >> |       battles_count | 1                         |
# >> |          created_at | 2026-05-02 07:29:04 +0900 |
# >> |          updated_at | 2026-05-02 07:29:04 +0900 |
# >> | chat_messages_count | 0                         |
# >> |                name | 共有将棋盤                |
# >> |---------------------+---------------------------|
# >> |----+-----------+---------+----------+-------------+----------+---------------------------+---------------------------|
# >> | id | battle_id | user_id | judge_id | location_id | position | created_at                | updated_at                |
# >> |----+-----------+---------+----------+-------------+----------+---------------------------+---------------------------|
# >> |  1 |         1 |       1 |        2 |           1 |        0 | 2026-05-02 07:29:04 +0900 | 2026-05-02 07:29:04 +0900 |
# >> |  2 |         1 |       2 |        1 |           2 |        1 | 2026-05-02 07:29:04 +0900 | 2026-05-02 07:29:04 +0900 |
# >> |  3 |         1 |       3 |        2 |           1 |        2 | 2026-05-02 07:29:04 +0900 | 2026-05-02 07:29:04 +0900 |
# >> |  4 |         1 |       4 |        1 |           2 |        3 | 2026-05-02 07:29:04 +0900 | 2026-05-02 07:29:04 +0900 |
# >> |----+-----------+---------+----------+-------------+----------+---------------------------+---------------------------|
# >> |----+------+-------------------+---------------------------+---------------------------+---------------------|
# >> | id | name | memberships_count | created_at                | updated_at                | chat_messages_count |
# >> |----+------+-------------------+---------------------------+---------------------------+---------------------|
# >> |  2 | b    |                 1 | 2026-05-02 07:29:04 +0900 | 2026-05-02 07:29:04 +0900 |                   0 |
# >> |  4 | d    |                 1 | 2026-05-02 07:29:04 +0900 | 2026-05-02 07:29:04 +0900 |                   0 |
# >> |  1 | a    |                 1 | 2026-05-02 07:29:04 +0900 | 2026-05-02 07:29:04 +0900 |                   0 |
# >> |  3 | c    |                 1 | 2026-05-02 07:29:04 +0900 | 2026-05-02 07:29:04 +0900 |                   0 |
# >> |----+------+-------------------+---------------------------+---------------------------+---------------------|
# >> |----+---------+---------+-----------+------------+---------------+----------+-------+------+---------------------------+---------------------------+------------|
# >> | id | room_id | user_id | win_count | lose_count | battles_count | win_rate | score | rank | created_at                | updated_at                | draw_count |
# >> |----+---------+---------+-----------+------------+---------------+----------+-------+------+---------------------------+---------------------------+------------|
# >> |  2 |       1 |       2 |         1 |          0 |             1 |      1.0 | 32767 |    1 | 2026-05-02 07:29:04 +0900 | 2026-05-02 07:29:04 +0900 |          0 |
# >> |  4 |       1 |       4 |         1 |          0 |             1 |      1.0 | 32767 |    1 | 2026-05-02 07:29:04 +0900 | 2026-05-02 07:29:04 +0900 |          0 |
# >> |  1 |       1 |       1 |         0 |          1 |             1 |      0.0 |     0 |    3 | 2026-05-02 07:29:04 +0900 | 2026-05-02 07:29:04 +0900 |          0 |
# >> |  3 |       1 |       3 |         0 |          1 |             1 |      0.0 |     0 |    3 | 2026-05-02 07:29:04 +0900 | 2026-05-02 07:29:04 +0900 |          0 |
# >> |----+---------+---------+-----------+------------+---------------+----------+-------+------+---------------------------+---------------------------+------------|
