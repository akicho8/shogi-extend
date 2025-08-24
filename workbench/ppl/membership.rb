require "#{__dir__}/setup"
Ppl.setup_for_workbench
Ppl::SeasonKeyVo["5"].update_by_records({ name: "alice", result_key: "維持", age: 1, win: 3, lose: 1 })
user = Ppl::User["alice"]
membership = user.memberships.sole
membership.result_info.name     # => "維持"
tp membership
tp user
# >> |------------------+---------------------------|
# >> |               id | 157                       |
# >> | season_id | 44                        |
# >> |          user_id | 95                        |
# >> |        result_id | 4                         |
# >> |              age | 1                         |
# >> |              win | 3                         |
# >> |             lose | 1                         |
# >> |               ox |                           |
# >> |       created_at | 2025-08-23 17:39:53 +0900 |
# >> |       updated_at | 2025-08-23 17:39:53 +0900 |
# >> |------------------+---------------------------|
# >> |----------------------------------+---------------------------|
# >> |                               id | 95                        |
# >> |                          rank_id | 3                         |
# >> |                        mentor_id |                           |
# >> |                             name | alice                     |
# >> |                          age_min | 1                         |
# >> |                          age_max | 1                         |
# >> |                  runner_up_count | 0                         |
# >> |                          win_max | 3                         |
# >> |                        total_win | 3                         |
# >> |                       total_lose | 1                         |
# >> |                        win_ratio | 0.75                      |
# >> |          promotion_membership_id |                           |
# >> |                    promotion_win |                           |
# >> | promotion_season_position |                           |
# >> |             memberships_first_id | 157                       |
# >> |              memberships_last_id | 157                       |
# >> |        deactivated_membership_id |                           |
# >> |                memberships_count | 1                         |
# >> |                       created_at | 2025-08-23 17:39:53 +0900 |
# >> |                       updated_at | 2025-08-23 17:39:53 +0900 |
# >> |----------------------------------+---------------------------|
