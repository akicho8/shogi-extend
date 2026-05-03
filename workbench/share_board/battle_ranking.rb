require "#{__dir__}/setup"
ShareBoard.setup(force: true)

room = ShareBoard::Room.create!(key: "dev_room")
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

ShareBoard::Roomship.find_each(&:save!)
ShareBoard::Room.find_each(&:redis_rebuild)

tp ShareBoard::Roomship
# >> |----+---------+---------+-----------+------------+---------------+----------+-------+------+---------------------------+---------------------------+------------|
# >> | id | room_id | user_id | win_count | lose_count | battles_count | win_rate | score | rank | created_at                | updated_at                | draw_count |
# >> |----+---------+---------+-----------+------------+---------------+----------+-------+------+---------------------------+---------------------------+------------|
# >> |  1 |       1 |       1 |        25 |          0 |            25 |      1.0 | 32767 |    1 | 2026-05-03 14:27:59 +0900 | 2026-05-03 14:28:00 +0900 |          0 |
# >> |  3 |       1 |       3 |        25 |          0 |            25 |      1.0 | 32767 |    1 | 2026-05-03 14:27:59 +0900 | 2026-05-03 14:28:00 +0900 |          0 |
# >> |  2 |       1 |       2 |         0 |         25 |            25 |      0.0 |     0 |    3 | 2026-05-03 14:27:59 +0900 | 2026-05-03 14:28:00 +0900 |          0 |
# >> |----+---------+---------+-----------+------------+---------------+----------+-------+------+---------------------------+---------------------------+------------|
