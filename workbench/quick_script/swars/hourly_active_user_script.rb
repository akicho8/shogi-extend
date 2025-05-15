require "./setup"

# sql
# object = QuickScriptSwars::HourlyActiveUserScript.new({}, batch_limit: 1)
# object.cache_write
# tp object.call

def reset
  Swars::Battle.destroy_all
  Swars::User.destroy_all
end

def entry(battled_at, user1, user2, grade_key1, grade_key2)
  Swars::Battle.create!(strike_plan: "糸谷流右玉", battled_at: battled_at) do |e|
    e.memberships.build(user: user1, grade_key: grade_key1)
    e.memberships.build(user: user2, grade_key: grade_key2)
  end
end

def aggregate
  object = QuickScript::Swars::HourlyActiveUserScript.new({}, batch_limit: 1)
  object.cache_write
  rows = object.call
  rows.sort_by { |e| e[:hour] }
end

user1 = Swars::User.create!
user2 = Swars::User.create!

# 同じ時間帯に2度対局しても1度の対局と見なす
reset
entry("2025-01-01 00:00", user1, user2, "二段", "四段")
entry("2025-01-01 00:59", user1, user2, "二段", "四段")
rows = aggregate                # => [{hour: 0, day_of_week: "祝日", grade_total: 14, grade_average: 7.0, uniq_user_count: 2, relative_strength: 0.0, grade_average_major: "三段", grade_average_minor: 100.0, relative_uniq_user_count: 0.0}]
rows.size == 1                  # => true

# 時間を跨いでいる別々に集計する
reset
entry("2025-01-01 00:00", user1, user2, "二段", "四段")
entry("2025-01-01 01:00", user1, user2, "五段", "五段")
rows = aggregate                # => [{hour: 0, day_of_week: "祝日", grade_total: 14, grade_average: 7.0, uniq_user_count: 2, relative_strength: 0.0, grade_average_major: "三段", grade_average_minor: 100.0, relative_uniq_user_count: 0.0}, {hour: 1, day_of_week: "祝日", grade_total: 10, grade_average: 5.0, uniq_user_count: 2, relative_strength: 1.0, grade_average_major: "五段", grade_average_minor: 100.0, relative_uniq_user_count: 0.0}]
rows.size                       # => 2
rows[0][:relative_strength]     # => 0.0
rows[1][:relative_strength]     # => 1.0

# 同じ時間帯に2度対局しても1度の対局と見なすが、日付が異なった場合は別の対局とする
reset
entry("2025-01-01 00:00", user1, user2, "二段", "四段")
entry("2025-01-02 00:59", user1, user2, "二段", "四段")
rows = aggregate
tp rows
rows.size == 2                  # => true

# entry("2025-01-01 00:00", user1, user2, "二段", "四段")
# entry("2025-01-01 01:00", user1, user2, "二段", "四段")

# >> [2025-05-15 19:05:50][QuickScript::Swars::HourlyActiveUserScript] Processing relation #1/1
# >> 2025-05-15T10:05:51.002Z pid=55473 tid=15cp INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> [2025-05-15 19:05:51][QuickScript::Swars::HourlyActiveUserScript] Processing relation #1/1
# >> [2025-05-15 19:05:52][QuickScript::Swars::HourlyActiveUserScript] Processing relation #1/1
# >> |------+-------------+-------------+---------------+-----------------+-------------------+---------------------+---------------------+--------------------------|
# >> | hour | day_of_week | grade_total | grade_average | uniq_user_count | relative_strength | grade_average_major | grade_average_minor | relative_uniq_user_count |
# >> |------+-------------+-------------+---------------+-----------------+-------------------+---------------------+---------------------+--------------------------|
# >> |    0 | 祝日        |          14 |           7.0 |               2 |               0.0 | 三段                |               100.0 |                      0.0 |
# >> |    0 | 木          |          14 |           7.0 |               2 |               0.0 | 三段                |               100.0 |                      0.0 |
# >> |------+-------------+-------------+---------------+-----------------+-------------------+---------------------+---------------------+--------------------------|
