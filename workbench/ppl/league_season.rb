require "#{__dir__}/setup"
Ppl.setup_for_workbench
Ppl::Updater.update_raw(5, { name: "alice" })
tp Ppl::User["alice"].league_seasons
Ppl::User["alice"].league_seasons.sole.season_number == 5
# >> |-----+------------+---------------------------+---------------------------|
# >> | id  | season_number | created_at                | updated_at                |
# >> |-----+------------+---------------------------+---------------------------|
# >> | 136 |          5 | 2025-08-14 18:28:24 +0900 | 2025-08-14 18:28:24 +0900 |
# >> |-----+------------+---------------------------+---------------------------|
