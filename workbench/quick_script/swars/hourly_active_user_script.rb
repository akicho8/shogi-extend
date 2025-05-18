require "./setup"

# QuickScript::Swars::HourlyActiveUserScript.new.cache_write
# QuickScript::Swars::HourlyActiveUserScript.new({}, batch_limit: 1).cache_write

# sql
# object = QuickScriptSwars::HourlyActiveUserScript.new({}, batch_limit: 1)
# object.cache_write
# tp object.call

def entry(battled_at, user1, user2, grade_key1, grade_key2)
  @battles << Swars::Battle.create!(strike_plan: "糸谷流右玉", battled_at: battled_at) do |e|
    e.memberships.build(user: user1, grade_key: grade_key1)
    e.memberships.build(user: user2, grade_key: grade_key2)
  end
end

def aggregate
  @battles = []
  yield
  scope = Swars::Membership.where(id: @battles.flat_map(&:membership_ids))
  object = QuickScript::Swars::HourlyActiveUserScript.new({}, batch_limit: 1, scope: scope)
  object.cache_write
  object.call.sort_by { |e| e[:hour] }
end

user1 = Swars::User.create!
user2 = Swars::User.create!

# 同じ時間帯に2度対局しても1度の対局と見なす
rows = aggregate do
  entry("2025-01-01 00:00", user1, user2, "二段", "四段")
  entry("2025-01-01 00:59", user1, user2, "二段", "四段")
end
rows.size == 1                  # => true

# 時間を跨いでいる別々に集計する
rows = aggregate do
  entry("2025-01-01 00:00", user1, user2, "二段", "四段")
  entry("2025-01-01 01:00", user1, user2, "五段", "五段")
end
rows.size                       # => 2
rows[0][:relative_strength] == 0 # => true
rows[1][:relative_strength] == 1 # => true

# 同じ時間帯に2度対局しても1度の対局と見なすが、日付が異なった場合は別の対局とする
rows = aggregate do
  entry("2025-01-01 00:00", user1, user2, "二段", "四段")
  entry("2025-01-02 00:59", user1, user2, "二段", "四段")
end
tp rows
rows.size == 2                  # => true

# entry("2025-01-01 00:00", user1, user2, "二段", "四段")
# entry("2025-01-01 01:00", user1, user2, "二段", "四段")
# >> 2025-05-18 08:56:01 1/1 100.00 % T1 HourlyActiveUserScript
# >> 2025-05-17T23:56:01.533Z pid=75156 tid=1ncs INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> 2025-05-18 08:56:02 1/1 100.00 % T1 HourlyActiveUserScript
# >> 2025-05-18 08:56:03 1/1 100.00 % T1 HourlyActiveUserScript
# >> |------+-------------+-------------+---------------+-----------------+-------------------+---------------------+---------------------+--------------------------|
# >> | hour | day_of_week | grade_total | grade_average | uniq_user_count | relative_strength | grade_average_major | grade_average_minor | relative_uniq_user_count |
# >> |------+-------------+-------------+---------------+-----------------+-------------------+---------------------+---------------------+--------------------------|
# >> |    0 | 祝日        |          14 |           7.0 |               2 |               0.0 | 三段                |               100.0 |                      0.0 |
# >> |    0 | 木          |          14 |           7.0 |               2 |               0.0 | 三段                |               100.0 |                      0.0 |
# >> |------+-------------+-------------+---------------+-----------------+-------------------+---------------------+---------------------+--------------------------|
