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

def aggregate(options = {})
  @battles = []
  yield
  scope = Swars::Membership.where(id: @battles.flat_map(&:membership_ids))
  object = QuickScript::Swars::HourlyActiveUserScript.new({}, {scope: scope, batch_size: 1, **options})
  object.cache_write
  object.call.sort_by { |e| e[:"時"] }
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
rows[0] == {:"時" => 0, :"人数" => 2, :"強さ" => -1.0, :"曜日" => "水", } # => true
rows[1] == {:"時" => 1, :"人数" => 2, :"強さ" =>  1.0, :"曜日" => "水", } # => true

# 同じ時間帯に2度対局しても1度の対局と見なすが、日付が異なった場合は別の対局とする
rows = aggregate do
  entry("2025-01-01 00:00", user1, user2, "二段", "四段")
  entry("2025-01-02 00:59", user1, user2, "二段", "四段")
end
rows.size == 2                  # => true
# >> 2025-06-05 22:45:48 1/4  25.00 % T1 HourlyActiveUserScript
# >> 2025-06-05 22:45:48 2/4  50.00 % T0 HourlyActiveUserScript
# >> 2025-06-05 22:45:48 3/4  75.00 % T0 HourlyActiveUserScript
# >> 2025-06-05 22:45:48 4/4 100.00 % T0 HourlyActiveUserScript
# >> 2025-06-05T13:45:49.003Z pid=78875 tid=1qsz INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> 2025-06-05 22:45:49 1/4  25.00 % T1 HourlyActiveUserScript
# >> 2025-06-05 22:45:49 2/4  50.00 % T0 HourlyActiveUserScript
# >> 2025-06-05 22:45:49 3/4  75.00 % T0 HourlyActiveUserScript
# >> 2025-06-05 22:45:49 4/4 100.00 % T0 HourlyActiveUserScript
# >> |----+------+------+------|
# >> | 時 | 人数 | 強さ | 曜日 |
# >> |----+------+------+------|
# >> |  0 |    2 | -1.0 | 水   |
# >> |  1 |    2 |  1.0 | 水   |
# >> |----+------+------+------|
# >> 2025-06-05 22:45:50 1/4  25.00 % T1 HourlyActiveUserScript
# >> 2025-06-05 22:45:50 2/4  50.00 % T0 HourlyActiveUserScript
# >> 2025-06-05 22:45:50 3/4  75.00 % T0 HourlyActiveUserScript
# >> 2025-06-05 22:45:50 4/4 100.00 % T0 HourlyActiveUserScript
