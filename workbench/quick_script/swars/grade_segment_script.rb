require "./setup"
# QuickScript::Swars::GradeSegmentScript.new.cache_write

def entry(user1, user2, grade_key1, grade_key2)
  @battles << Swars::Battle.create!(strike_plan: "糸谷流右玉") do |e|
    e.memberships.build(user: user1, grade_key: grade_key1)
    e.memberships.build(user: user2, grade_key: grade_key2)
  end
end

def aggregate
  @battles = []
  yield
  scope = Swars::Membership.where(id: @battles.flat_map(&:membership_ids))
  object = QuickScript::Swars::GradeSegmentScript.new({}, batch_limit: 1, scope: scope)
  object.cache_write
  object.call
end

user1 = Swars::User.create!
user2 = Swars::User.create!

rows = aggregate do
  entry(user1, user2, "二段", "四段")
end
rows # => [{入玉: 0.0, 手数: 131.0, 投了: 1.0, 棋力: "四段", 衝突: 38.0, 開戦: 58.0, 棋力順: 6, 切断逃亡: 0.0, 時間切れ: 0.0, 詰まされ: 0.0, 連続王手の千日手: 0.0}, {入玉: 0.0, 手数: 131.0, 投了: 0.0, 棋力: "二段", 衝突: 38.0, 開戦: 58.0, 棋力順: 8, 切断逃亡: 0.0, 時間切れ: 0.0, 詰まされ: 0.0, 連続王手の千日手: 0.0}]
tp rows
# >> 2025-05-21 19:25:55 1/1 100.00 % T1 GradeSegmentScript
# >> 2025-05-21T10:25:55.169Z pid=58105 tid=1afl INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> |------+-------+------+------+------+------+--------+----------+----------+----------+------------------|
# >> | 入玉 | 手数  | 投了 | 棋力 | 衝突 | 開戦 | 棋力順 | 切断逃亡 | 時間切れ | 詰まされ | 連続王手の千日手 |
# >> |------+-------+------+------+------+------+--------+----------+----------+----------+------------------|
# >> |  0.0 | 131.0 |  1.0 | 四段 | 38.0 | 58.0 |      6 |      0.0 |      0.0 |      0.0 |              0.0 |
# >> |  0.0 | 131.0 |  0.0 | 二段 | 38.0 | 58.0 |      8 |      0.0 |      0.0 |      0.0 |              0.0 |
# >> |------+-------+------+------+------+------+--------+----------+----------+----------+------------------|
