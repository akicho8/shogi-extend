require "#{__dir__}/setup"
ShareBoard.setup(force: true)

room_key = "dev_room"
room = ShareBoard::Room.create!(key: "dev_room", name: "(room.name)")
25.times do |i|
  records = [
    { user_name: "alice", location_key: "black", judge_key: "win",  },
    { user_name: "bob",   location_key: "white", judge_key: "lose", },
    { user_name: "carol", location_key: "black", judge_key: "win",  },
  ]
  room.battles.create!(win_location_key: "black", created_at: "2000-01-01".to_date + i) do |e|
    e.memberships.build(records)
  end
end

# s { ShareBoard::BattleList.new(room_key: room_key).call }
# pp ShareBoard::BattleList.new(room_key: room_key).call
ShareBoard::Battle.count    # => 25

ShareBoard::Roomship.find_each(&:save!)
ShareBoard::Room.find_each(&:redis_rebuild)

tp ShareBoard::Roomship
# >> |----+---------+---------+-----------+------------+---------------+----------+-------+------+---------------------------+---------------------------|
# >> | id | room_id | user_id | win_count | lose_count | battles_count | win_rate | score | rank | created_at                | updated_at                |
# >> |----+---------+---------+-----------+------------+---------------+----------+-------+------+---------------------------+---------------------------|
# >> |  1 |       1 |       1 |        25 |          0 |            25 |      1.0 | 32767 |    1 | 2026-04-30 18:35:28 +0900 | 2026-04-30 18:35:29 +0900 |
# >> |  3 |       1 |       3 |        25 |          0 |            25 |      1.0 | 32767 |    1 | 2026-04-30 18:35:28 +0900 | 2026-04-30 18:35:29 +0900 |
# >> |  2 |       1 |       2 |         0 |         25 |            25 |      0.0 |     0 |    3 | 2026-04-30 18:35:28 +0900 | 2026-04-30 18:35:29 +0900 |
# >> |----+---------+---------+-----------+------------+---------------+----------+-------+------+---------------------------+---------------------------|
