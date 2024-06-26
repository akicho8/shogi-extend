#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)
ShareBoard.setup(force: true)

params = {
  :room_key  => "dev_room",
  :title     => "共有将棋盤",
  :sfen      => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1",
  :turn      => 0,
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
# >> |---------------+---------------------------|
# >> |            id | 9                         |
# >> |           key | dev_room                  |
# >> | battles_count | 1                         |
# >> |    created_at | 2023-03-26 18:42:42 +0900 |
# >> |    updated_at | 2023-03-26 18:42:42 +0900 |
# >> |---------------+---------------------------|
# >> |------------+-------------------------------------------------------------------------------|
# >> |         id | 6                                                                             |
# >> |    room_id | 9                                                                             |
# >> |        key | 62300f7ea354c670d5c45a81d080e386                                              |
# >> |      title | 共有将棋盤                                                                    |
# >> |       sfen | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 |
# >> |       turn | 0                                                                             |
# >> | created_at | 2023-03-26 18:42:42 +0900                                                     |
# >> | updated_at | 2023-03-26 18:42:42 +0900                                                     |
# >> |------------+-------------------------------------------------------------------------------|
# >> |----+-----------+---------+----------+-------------+----------+---------------------------+---------------------------|
# >> | id | battle_id | user_id | judge_id | location_id | position | created_at                | updated_at                |
# >> |----+-----------+---------+----------+-------------+----------+---------------------------+---------------------------|
# >> | 21 |         6 |      17 |        2 |           1 |        0 | 2023-03-26 18:42:42 +0900 | 2023-03-26 18:42:42 +0900 |
# >> | 22 |         6 |      18 |        1 |           2 |        1 | 2023-03-26 18:42:42 +0900 | 2023-03-26 18:42:42 +0900 |
# >> | 23 |         6 |      19 |        2 |           1 |        2 | 2023-03-26 18:42:42 +0900 | 2023-03-26 18:42:42 +0900 |
# >> | 24 |         6 |      20 |        1 |           2 |        3 | 2023-03-26 18:42:42 +0900 | 2023-03-26 18:42:42 +0900 |
# >> |----+-----------+---------+----------+-------------+----------+---------------------------+---------------------------|
# >> |----+------+-------------------+---------------------------+---------------------------|
# >> | id | name | memberships_count | created_at                | updated_at                |
# >> |----+------+-------------------+---------------------------+---------------------------|
# >> | 17 | a    |                 1 | 2023-03-26 18:42:42 +0900 | 2023-03-26 18:42:42 +0900 |
# >> | 18 | b    |                 1 | 2023-03-26 18:42:42 +0900 | 2023-03-26 18:42:42 +0900 |
# >> | 19 | c    |                 1 | 2023-03-26 18:42:42 +0900 | 2023-03-26 18:42:42 +0900 |
# >> | 20 | d    |                 1 | 2023-03-26 18:42:42 +0900 | 2023-03-26 18:42:42 +0900 |
# >> |----+------+-------------------+---------------------------+---------------------------|
