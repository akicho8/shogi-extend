require "./setup"

battles = QuickScript::Swars::StandardScoreScript.mock_setup
ids = battles.flat_map { |e| e.memberships.pluck(:id) }
scope = ::Swars::Membership.where(id: ids)
QuickScript::Swars::StandardScoreScript.new({}, {scope: scope, batch_size: 1}).cache_write
tp QuickScript::Swars::StandardScoreScript.new.aggregate # => {九段: 1, 初段: 2}
tp QuickScript::Swars::StandardScoreScript.new.as_general_json
exit

battles = QuickScript::Swars::StandardScoreScript.mock_setup
ids = battles.flat_map { |e| e.memberships.pluck(:id) }
s = ::Swars::Membership.where(id: ids)
s = s.joins(:battle => [:xmode, :imode])
s = s.joins(:grade)
s = s.group("swars_imodes.key")
s = s.group("swars_xmodes.key")
s = s.group("swars_grades.key")
s = s.select("user_id")
s = s.distinct
sql
tp s.count
# tp s.collect(&:attributes)
exit

battles = QuickScript::Swars::StandardScoreScript.mock_setup
ids = battles.flat_map { |e| e.memberships.pluck(:id) }
scope = ::Swars::Membership.where(id: ids)
a = QuickScript::Swars::StandardScoreScript.new({}, {scope: scope, one_shot: true}).aggregate_now
b = QuickScript::Swars::StandardScoreScript.new({}, {scope: scope, one_shot: false, batch_size: 1}).aggregate_now
p a.values.sum
p b.values.sum
exit

tp QuickScript::Swars::StandardScoreScript.new.as_general_json
# tp QuickScript::Swars::StandardScoreScript.new.aggregate
exit

battles = QuickScript::Swars::StandardScoreScript.mock_setup
ids = battles.flat_map { |e| e.memberships.pluck(:id) }
scope = ::Swars::Membership.where(id: ids)
QuickScript::Swars::StandardScoreScript.new({}, {scope: scope, batch_limit: 1}).cache_write
exit

e = QuickScript::Swars::StandardScoreScript.new.aggregate # => 
e == { :"九段" => 1, :"初段" => 2 }
tp QuickScript::Swars::StandardScoreScript.new.sd_merged_grade_infos
# >> 2025-06-05 14:26:20 1/4  25.00 % T1 StandardScoreScript
# >> 2025-06-05 14:26:20 2/4  50.00 % T0 StandardScoreScript
# >> 2025-06-05 14:26:20 3/4  75.00 % T0 StandardScoreScript
# >> 2025-06-05 14:26:20 4/4 100.00 % T0 StandardScoreScript
# >> 2025-06-05T05:26:20.376Z pid=23246 tid=gfa INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> |------+---|
# >> | 九段 | 1 |
# >> | 初段 | 2 |
# >> |------+---|
# >> |------+------|
# >> | 棋力 | 人数 |
# >> |------+------|
# >> | 十段 |    0 |
# >> | 九段 |    1 |
# >> | 八段 |    0 |
# >> | 七段 |    0 |
# >> | 六段 |    0 |
# >> | 五段 |    0 |
# >> | 四段 |    0 |
# >> | 三段 |    0 |
# >> | 二段 |    0 |
# >> | 初段 |    2 |
# >> | 1級  |    0 |
# >> | 2級  |    0 |
# >> | 3級  |    0 |
# >> | 4級  |    0 |
# >> | 5級  |    0 |
# >> | 6級  |    0 |
# >> | 7級  |    0 |
# >> | 8級  |    0 |
# >> | 9級  |    0 |
# >> | 10級 |    0 |
# >> | 11級 |    0 |
# >> | 12級 |    0 |
# >> | 13級 |    0 |
# >> | 14級 |    0 |
# >> | 15級 |    0 |
# >> | 16級 |    0 |
# >> | 17級 |    0 |
# >> | 18級 |    0 |
# >> | 19級 |    0 |
# >> | 20級 |    0 |
# >> | 21級 |    0 |
# >> | 22級 |    0 |
# >> | 23級 |    0 |
# >> | 24級 |    0 |
# >> | 25級 |    0 |
# >> | 26級 |    0 |
# >> | 27級 |    0 |
# >> | 28級 |    0 |
# >> | 29級 |    0 |
# >> | 30級 |    0 |
# >> |------+------|
