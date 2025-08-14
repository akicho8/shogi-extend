require "#{__dir__}/setup"
Ppl.setup_for_workbench
Ppl::Updater.update_raw(5, { name: "alice", result_key: "維持", age: 1, win: 3 })
membership = Ppl::User["alice"].memberships.sole
membership.result_info.name     # => "維持"
tp membership
# >> |------------+---------------------------|
# >> |         id | 2541                      |
# >> |  league_season_id | 138                       |
# >> |    user_id | 605                       |
# >> |  result_id | 4                         |
# >> |  start_pos | 0                         |
# >> |        age | 1                         |
# >> |        win | 3                         |
# >> |       lose | 0                         |
# >> |         ox |                           |
# >> | created_at | 2025-08-14 18:31:13 +0900 |
# >> | updated_at | 2025-08-14 18:31:13 +0900 |
# >> |------------+---------------------------|
