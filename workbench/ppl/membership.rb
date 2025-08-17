require "#{__dir__}/setup"
Ppl.setup_for_workbench
Ppl::Updater.update_raw(5, { name: "alice", result_key: "維持", age: 1, win: 3, lose: 1 })
user = Ppl::User["alice"]
membership = user.memberships.sole
membership.result_info.name     # => "維持"
tp membership
tp user
# >> |------------------+---------------------------|
# >> |               id | 4                         |
# >> | league_season_id | 7                         |
# >> |          user_id | 4                         |
# >> |        result_id | 4                         |
# >> |        start_pos | 0                         |
# >> |              age | 1                         |
# >> |              win | 3                         |
# >> |             lose | 1                         |
# >> |               ox |                           |
# >> |       created_at | 2025-08-17 14:18:12 +0900 |
# >> |       updated_at | 2025-08-17 14:18:12 +0900 |
# >> |------------------+---------------------------|
# >> |-------------------------+---------------------------|
# >> |                      id | 4                         |
# >> |               mentor_id |                           |
# >> |                    name | alice                     |
# >> |                 age_min | 1                         |
# >> |                 age_max | 1                         |
# >> |         runner_up_count | 0                         |
# >> |                 win_max | 3                         |
# >> |               total_win | 3                         |
# >> |              total_lose | 1                         |
# >> |               win_ratio | 0.75                      |
# >> | promotion_membership_id |                           |
# >> | promotion_season_number |                           |
# >> |           promotion_win |                           |
# >> |    memberships_first_id | 4                         |
# >> |       season_number_min | 5                         |
# >> |     memberships_last_id | 4                         |
# >> |       season_number_max | 5                         |
# >> |       memberships_count | 1                         |
# >> |              created_at | 2025-08-17 14:18:12 +0900 |
# >> |              updated_at | 2025-08-17 14:18:12 +0900 |
# >> |-------------------------+---------------------------|
