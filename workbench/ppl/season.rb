require "#{__dir__}/setup"
Ppl.setup_for_workbench
Ppl::Season.latest_or_base_key  # => S49
Ppl::SeasonKeyVo["5"].users_update({ name: "alice" })
tp Ppl::User["alice"].seasons
Ppl::User["alice"].seasons.sole.key # => 5
Ppl::Season.latest_key              # => 5
# >> |-----+-----+----------+---------------------------+---------------------------|
# >> | id  | key | position | created_at                | updated_at                |
# >> |-----+-----+----------+---------------------------+---------------------------|
# >> | 351 |   5 |        0 | 2025-08-24 20:15:08 +0900 | 2025-08-24 20:15:08 +0900 |
# >> |-----+-----+----------+---------------------------+---------------------------|
