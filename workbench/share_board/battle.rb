require File.expand_path('../../../config/environment', __FILE__)
# ShareBoard.setup(force: true)

Judge.count                     # => 3
Location.count                  # => 2

room = ShareBoard::Room.create!
room.battles.create! do |e|
  e.memberships.build([
      { user_name: "alice", location_key: "black", judge_key: "win",  },
      { user_name: "bob",   location_key: "white", judge_key: "lose", },
      { user_name: "carol", location_key: "black", judge_key: "win",  },
    ])
end

room # => #<ShareBoard::Room id: 5, key: "e80154f46ebd60e8c4e0d3b5ec6a566d", battles_count: 1, created_at: "2025-08-01 20:43:17.000000000 +0900", updated_at: "2025-08-01 20:43:18.000000000 +0900", chat_messages_count: 0>
room.battles_count              # => 1
room.memberships.count          # => 3
room.users.count                # => 3
battle = room.battles.first
tp ShareBoard::Roomship
tp battle
tp battle.users
tp battle.memberships

battle.memberships.location_of(:black) # => #<ActiveRecord::AssociationRelation [#<ShareBoard::Membership id: 12, battle_id: 6, user_id: 1, judge_id: 1, location_id: 1, position: 0, created_at: "2025-08-01 20:43:18.000000000 +0900", updated_at: "2025-08-01 20:43:18.000000000 +0900">, #<ShareBoard::Membership id: 14, battle_id: 6, user_id: 3, judge_id: 1, location_id: 1, position: 2, created_at: "2025-08-01 20:43:18.000000000 +0900", updated_at: "2025-08-01 20:43:18.000000000 +0900">]>
battle.memberships.location_of(:white) # => #<ActiveRecord::AssociationRelation [#<ShareBoard::Membership id: 13, battle_id: 6, user_id: 2, judge_id: 2, location_id: 2, position: 1, created_at: "2025-08-01 20:43:18.000000000 +0900", updated_at: "2025-08-01 20:43:18.000000000 +0900">]>

battle.memberships.black        # => #<ActiveRecord::AssociationRelation [#<ShareBoard::Membership id: 12, battle_id: 6, user_id: 1, judge_id: 1, location_id: 1, position: 0, created_at: "2025-08-01 20:43:18.000000000 +0900", updated_at: "2025-08-01 20:43:18.000000000 +0900">, #<ShareBoard::Membership id: 14, battle_id: 6, user_id: 3, judge_id: 1, location_id: 1, position: 2, created_at: "2025-08-01 20:43:18.000000000 +0900", updated_at: "2025-08-01 20:43:18.000000000 +0900">]>
battle.memberships.white        # => #<ActiveRecord::AssociationRelation [#<ShareBoard::Membership id: 13, battle_id: 6, user_id: 2, judge_id: 2, location_id: 2, position: 1, created_at: "2025-08-01 20:43:18.000000000 +0900", updated_at: "2025-08-01 20:43:18.000000000 +0900">]>

battle.black                    # => #<ActiveRecord::Associations::CollectionProxy [#<ShareBoard::Membership id: 12, battle_id: 6, user_id: 1, judge_id: 1, location_id: 1, position: 0, created_at: "2025-08-01 20:43:18.000000000 +0900", updated_at: "2025-08-01 20:43:18.000000000 +0900">, #<ShareBoard::Membership id: 14, battle_id: 6, user_id: 3, judge_id: 1, location_id: 1, position: 2, created_at: "2025-08-01 20:43:18.000000000 +0900", updated_at: "2025-08-01 20:43:18.000000000 +0900">]>
battle.white                    # => #<ActiveRecord::Associations::CollectionProxy [#<ShareBoard::Membership id: 13, battle_id: 6, user_id: 2, judge_id: 2, location_id: 2, position: 1, created_at: "2025-08-01 20:43:18.000000000 +0900", updated_at: "2025-08-01 20:43:18.000000000 +0900">]>

# >> |----+---------+---------+-----------+------------+---------------+----------+-------+------+---------------------------+---------------------------|
# >> | id | room_id | user_id | win_count | lose_count | battles_count | win_rate | score | rank | created_at                | updated_at                |
# >> |----+---------+---------+-----------+------------+---------------+----------+-------+------+---------------------------+---------------------------|
# >> |  5 |       3 |       1 |         1 |          0 |             1 |      1.0 |     1 |    1 | 2025-08-01 20:43:00 +0900 | 2025-08-01 20:43:00 +0900 |
# >> |  7 |       3 |       3 |         1 |          0 |             1 |      1.0 |     1 |    1 | 2025-08-01 20:43:00 +0900 | 2025-08-01 20:43:00 +0900 |
# >> |  1 |       1 |       1 |         1 |          0 |             1 |      1.0 |     1 |    3 | 2025-08-01 20:27:23 +0900 | 2025-08-01 20:27:23 +0900 |
# >> |  3 |       1 |       3 |         1 |          0 |             1 |      1.0 |     1 |    3 | 2025-08-01 20:27:23 +0900 | 2025-08-01 20:27:23 +0900 |
# >> |  4 |       2 |       1 |         0 |          2 |             2 |      0.0 |     0 |    3 | 2025-08-01 20:33:44 +0900 | 2025-08-01 20:33:58 +0900 |
# >> |  8 |       4 |       1 |         1 |          0 |             1 |      1.0 |     1 |    3 | 2025-08-01 20:43:11 +0900 | 2025-08-01 20:43:11 +0900 |
# >> | 10 |       4 |       3 |         1 |          0 |             1 |      1.0 |     1 |    3 | 2025-08-01 20:43:11 +0900 | 2025-08-01 20:43:11 +0900 |
# >> | 11 |       5 |       1 |         1 |          0 |             1 |      1.0 |     1 |    3 | 2025-08-01 20:43:18 +0900 | 2025-08-01 20:43:18 +0900 |
# >> | 13 |       5 |       3 |         1 |          0 |             1 |      1.0 |     1 |    3 | 2025-08-01 20:43:18 +0900 | 2025-08-01 20:43:18 +0900 |
# >> |  6 |       3 |       2 |         0 |          1 |             1 |      0.0 |     0 |    5 | 2025-08-01 20:43:00 +0900 | 2025-08-01 20:43:00 +0900 |
# >> |  9 |       4 |       2 |         0 |          1 |             1 |      0.0 |     0 |    5 | 2025-08-01 20:43:11 +0900 | 2025-08-01 20:43:11 +0900 |
# >> |  2 |       1 |       2 |         0 |          1 |             1 |      0.0 |     0 |    6 | 2025-08-01 20:27:23 +0900 | 2025-08-01 20:27:23 +0900 |
# >> | 12 |       5 |       2 |         0 |          1 |             1 |      0.0 |     0 |    6 | 2025-08-01 20:43:18 +0900 | 2025-08-01 20:43:18 +0900 |
# >> |----+---------+---------+-----------+------------+---------------+----------+-------+------+---------------------------+---------------------------|
# >> |-----------------+----------------------------------------------------------------------------------------------------------|
# >> |              id | 6                                                                                                        |
# >> |         room_id | 5                                                                                                        |
# >> |             key | f2c5128e3832df2ea321ce7551dbf82a                                                                         |
# >> |           title |                                                                                                          |
# >> |            sfen | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d 8h2b+ 3a2b |
# >> |            turn | 4                                                                                                        |
# >> | win_location_id | 1                                                                                                        |
# >> |        position | 0                                                                                                        |
# >> |      created_at | 2025-08-01 20:43:18 +0900                                                                                |
# >> |      updated_at | 2025-08-01 20:43:18 +0900                                                                                |
# >> |-----------------+----------------------------------------------------------------------------------------------------------|
# >> |----+-------+-------------------+---------------------------+---------------------------+---------------------|
# >> | id | name  | memberships_count | created_at                | updated_at                | chat_messages_count |
# >> |----+-------+-------------------+---------------------------+---------------------------+---------------------|
# >> |  1 | alice |                 6 | 2025-08-01 20:27:23 +0900 | 2025-08-01 20:43:18 +0900 |                   2 |
# >> |  2 | bob   |                 4 | 2025-08-01 20:27:23 +0900 | 2025-08-01 20:43:18 +0900 |                   0 |
# >> |  3 | carol |                 4 | 2025-08-01 20:27:23 +0900 | 2025-08-01 20:43:18 +0900 |                   0 |
# >> |----+-------+-------------------+---------------------------+---------------------------+---------------------|
# >> |----+-----------+---------+----------+-------------+----------+---------------------------+---------------------------|
# >> | id | battle_id | user_id | judge_id | location_id | position | created_at                | updated_at                |
# >> |----+-----------+---------+----------+-------------+----------+---------------------------+---------------------------|
# >> | 12 |         6 |       1 |        1 |           1 |        0 | 2025-08-01 20:43:18 +0900 | 2025-08-01 20:43:18 +0900 |
# >> | 13 |         6 |       2 |        2 |           2 |        1 | 2025-08-01 20:43:18 +0900 | 2025-08-01 20:43:18 +0900 |
# >> | 14 |         6 |       3 |        1 |           1 |        2 | 2025-08-01 20:43:18 +0900 | 2025-08-01 20:43:18 +0900 |
# >> |----+-----------+---------+----------+-------------+----------+---------------------------+---------------------------|
