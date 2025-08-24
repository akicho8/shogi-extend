require "#{__dir__}/setup"
Ppl.setup_for_workbench
Ppl::SeasonKeyVo["5"].update_by_records({ name: "XA", result_key: "維持" })
Ppl::SeasonKeyVo["6"].update_by_records({ name: "BX", result_key: "維持" })
Ppl::User.plus_minus_search("A -B").collect(&:name) == ["XA"] # => true

Ppl.setup_for_workbench
Ppl::SeasonKeyVo["5"].update_by_records({ name: "XA", result_key: "維持" })
Ppl::SeasonKeyVo["6"].update_by_records({ name: "BX", result_key: "維持" })
Ppl::User.plus_minus_search("A -B").collect(&:name) == ["XA"] # => true

Ppl.setup_for_workbench
Ppl::SeasonKeyVo["5"].update_by_records({ name: "alice", result_key: "維持", age: 1, win: 3 })
Ppl::SeasonKeyVo["6"].update_by_records({ name: "alice", result_key: "次点", age: 2, win: 2 })
Ppl::SeasonKeyVo["7"].update_by_records({ name: "alice", result_key: "昇段", age: 3, win: 1 })
user = Ppl::User["alice"]
user.age_min                         # => 1
user.age_max                         # => 3
user.runner_up_count                 # => 1
user.win_max                         # => 3
user.promotion_membership.season.key # => "7"
user.promotion_season_position       # => 2
user.promotion_win                   # => 1
user.memberships_first.season.key    # => "5"
user.memberships_last.season.key     # => "7"

Ppl.setup_for_workbench
Ppl::SeasonKeyVo["5"].update_by_records({ name: "alice", result_key: "維持" })
Ppl::User["alice"].deactivated_membership # => nil
Ppl::SeasonKeyVo["6"].update_by_records({ name: "bob",   result_key: "維持" })
Ppl::User["alice"].deactivated_membership # => #<Ppl::Membership id: 5354, season_id: 201, user_id: 816, result_id: 4, age: 0, win: nil, lose: nil, ox: "", created_at: "2025-08-24 10:51:51.965650000 +0900", updated_at: "2025-08-24 10:51:51.965650000 +0900">

tp Ppl::Season
tp Ppl::User
tp Ppl::Membership
# >> |-----+-----+----------+---------------------------+---------------------------|
# >> | id  | key | position | created_at                | updated_at                |
# >> |-----+-----+----------+---------------------------+---------------------------|
# >> | 201 |   5 |        0 | 2025-08-24 10:51:51 +0900 | 2025-08-24 10:51:51 +0900 |
# >> | 202 |   6 |        1 | 2025-08-24 10:51:51 +0900 | 2025-08-24 10:51:51 +0900 |
# >> |-----+-----+----------+---------------------------+---------------------------|
# >> |-----+---------+-----------+-------+---------+---------+-----------------+---------+-----------+-------------------------+---------------+---------------------------+----------------------+---------------------+---------------------------+-------------------+---------------------------+---------------------------|
# >> | id  | rank_id | mentor_id | name  | age_min | age_max | runner_up_count | win_max | win_ratio | promotion_membership_id | promotion_win | promotion_season_position | memberships_first_id | memberships_last_id | deactivated_membership_id | memberships_count | created_at                | updated_at                |
# >> |-----+---------+-----------+-------+---------+---------+-----------------+---------+-----------+-------------------------+---------------+---------------------------+----------------------+---------------------+---------------------------+-------------------+---------------------------+---------------------------|
# >> | 816 |       5 |           | alice |       0 |       0 |                 |         |           |                         |               |                           |                 5354 |                5354 |                      5354 |                 1 | 2025-08-24 10:51:51 +0900 | 2025-08-24 10:51:52 +0900 |
# >> | 817 |       3 |           | bob   |       0 |       0 |                 |         |           |                         |               |                           |                 5355 |                5355 |                           |                 1 | 2025-08-24 10:51:51 +0900 | 2025-08-24 10:51:51 +0900 |
# >> |-----+---------+-----------+-------+---------+---------+-----------------+---------+-----------+-------------------------+---------------+---------------------------+----------------------+---------------------+---------------------------+-------------------+---------------------------+---------------------------|
# >> |------+-----------+---------+-----------+-----+-----+------+----+---------------------------+---------------------------|
# >> | id   | season_id | user_id | result_id | age | win | lose | ox | created_at                | updated_at                |
# >> |------+-----------+---------+-----------+-----+-----+------+----+---------------------------+---------------------------|
# >> | 5354 |       201 |     816 |         4 |   0 |     |      |    | 2025-08-24 10:51:51 +0900 | 2025-08-24 10:51:51 +0900 |
# >> | 5355 |       202 |     817 |         4 |   0 |     |      |    | 2025-08-24 10:51:51 +0900 | 2025-08-24 10:51:51 +0900 |
# >> |------+-----------+---------+-----------+-----+-----+------+----+---------------------------+---------------------------|
