require "#{__dir__}/setup"
Ppl.setup_for_workbench
Ppl::Updater.update_raw(5, { name: "XA", result_key: "維持" })
Ppl::Updater.update_raw(6, { name: "BX", result_key: "維持" })
Ppl::User.plus_minus_search("A -B").collect(&:name) == ["XA"] # => true

Ppl.setup_for_workbench
Ppl::Updater.update_raw(5, { name: "XA", result_key: "維持" })
Ppl::Updater.update_raw(6, { name: "BX", result_key: "維持" })
Ppl::User.plus_minus_search("A -B").collect(&:name) == ["XA"] # => true

Ppl.setup_for_workbench
Ppl::Updater.update_raw(5, { name: "alice", result_key: "維持", age: 1, win: 3 })
Ppl::Updater.update_raw(6, { name: "alice", result_key: "次点", age: 2, win: 2 })
Ppl::Updater.update_raw(7, { name: "alice", result_key: "昇段", age: 3, win: 1 })
user = Ppl::User["alice"]
user.age_min                                # => 1
user.age_max                                # => 3
user.runner_up_count                        # => 1
user.win_max                                # => 3
user.promotion_membership.season.key # => "7"
user.promotion_season_position       # => 2
user.promotion_win                          # => 1
user.memberships_first.season.key    # => "5"
user.memberships_last.season.key     # => "7"

Ppl.setup_for_workbench
Ppl::Updater.update_raw("5", { name: "alice", result_key: "維持" })
Ppl::User["alice"].deactivated_membership # => nil
Ppl::Updater.update_raw("6", { name: "bob",   result_key: "維持" })
Ppl::User["alice"].deactivated_membership # => #<Ppl::Membership id: 152, season_id: 39, user_id: 90, result_id: 4, age: nil, win: 0, lose: 0, ox: "", created_at: "2025-08-23 16:42:47.046583000 +0900", updated_at: "2025-08-23 16:42:47.046583000 +0900">

tp Ppl::Season
tp Ppl::User
tp Ppl::Membership
# >> |----+-----+----------+---------------------------+---------------------------|
# >> | id | key | position | created_at                | updated_at                |
# >> |----+-----+----------+---------------------------+---------------------------|
# >> | 39 |   5 |        0 | 2025-08-23 16:42:47 +0900 | 2025-08-23 16:42:47 +0900 |
# >> | 40 |   6 |        1 | 2025-08-23 16:42:47 +0900 | 2025-08-23 16:42:47 +0900 |
# >> |----+-----+----------+---------------------------+---------------------------|
# >> |----+---------+-----------+-------+---------+---------+-----------------+---------+-----------+------------+-----------+-------------------------+---------------+----------------------------------+----------------------+---------------------+---------------------------+-------------------+---------------------------+---------------------------|
# >> | id | rank_id | mentor_id | name  | age_min | age_max | runner_up_count | win_max | total_win | total_lose | win_ratio | promotion_membership_id | promotion_win | promotion_season_position | memberships_first_id | memberships_last_id | deactivated_membership_id | memberships_count | created_at                | updated_at                |
# >> |----+---------+-----------+-------+---------+---------+-----------------+---------+-----------+------------+-----------+-------------------------+---------------+----------------------------------+----------------------+---------------------+---------------------------+-------------------+---------------------------+---------------------------|
# >> | 90 |       4 |           | alice |         |         |               0 |       0 |         0 |          0 |       0.0 |                         |               |                                  |                  152 |                 152 |                       152 |                 1 | 2025-08-23 16:42:47 +0900 | 2025-08-23 16:42:47 +0900 |
# >> | 91 |       3 |           | bob   |         |         |               0 |       0 |         0 |          0 |       0.0 |                         |               |                                  |                  153 |                 153 |                           |                 1 | 2025-08-23 16:42:47 +0900 | 2025-08-23 16:42:47 +0900 |
# >> |----+---------+-----------+-------+---------+---------+-----------------+---------+-----------+------------+-----------+-------------------------+---------------+----------------------------------+----------------------+---------------------+---------------------------+-------------------+---------------------------+---------------------------|
# >> |-----+------------------+---------+-----------+-----+-----+------+----+---------------------------+---------------------------|
# >> | id  | season_id | user_id | result_id | age | win | lose | ox | created_at                | updated_at                |
# >> |-----+------------------+---------+-----------+-----+-----+------+----+---------------------------+---------------------------|
# >> | 152 |               39 |      90 |         4 |     |   0 |    0 |    | 2025-08-23 16:42:47 +0900 | 2025-08-23 16:42:47 +0900 |
# >> | 153 |               40 |      91 |         4 |     |   0 |    0 |    | 2025-08-23 16:42:47 +0900 | 2025-08-23 16:42:47 +0900 |
# >> |-----+------------------+---------+-----------+-----+-----+------+----+---------------------------+---------------------------|
