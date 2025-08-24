require "#{__dir__}/setup"
Ppl.setup_for_workbench
Ppl::SeasonKeyVo["5"].users_update({ name: "alice", result_key: "維持", age: 1, win: 3, lose: 1 })
user = Ppl::User["alice"]
membership = user.memberships.sole
membership.result_info.name     # => "維持"
tp membership
tp user
# >> |------------+---------------------------|
# >> |         id | 5356                      |
# >> |  season_id | 203                       |
# >> |    user_id | 818                       |
# >> |  result_id | 4                         |
# >> |        age | 1                         |
# >> |        win | 3                         |
# >> |       lose | 1                         |
# >> |         ox |                           |
# >> | created_at | 2025-08-24 19:09:40 +0900 |
# >> | updated_at | 2025-08-24 19:09:40 +0900 |
# >> |------------+---------------------------|
# >> |---------------------------+---------------------------|
# >> |                        id | 818                       |
# >> |                   rank_id | 3                         |
# >> |                 mentor_id |                           |
# >> |                      name | alice                     |
# >> |                   age_min | 1                         |
# >> |                   age_max | 1                         |
# >> |           runner_up_count |                           |
# >> |                   win_max | 3                         |
# >> |                 win_ratio |                           |
# >> |   promotion_membership_id |                           |
# >> |             promotion_win |                           |
# >> | promotion_season_position |                           |
# >> |      memberships_first_id | 5356                      |
# >> |       memberships_last_id | 5356                      |
# >> | deactivated_membership_id |                           |
# >> |         memberships_count | 1                         |
# >> |                created_at | 2025-08-24 19:09:40 +0900 |
# >> |                updated_at | 2025-08-24 19:09:40 +0900 |
# >> |---------------------------+---------------------------|
