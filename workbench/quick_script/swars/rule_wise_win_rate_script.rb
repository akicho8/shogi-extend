require "./setup"
scope = Swars::Membership.where(id: ::Swars::Membership.last(1000).collect(&:id))
object = QuickScript::Swars::RuleWiseWinRateScript.new({}, {scope: scope})
object.cache_write
tp object.rows
# >> 2025-05-15T11:11:15.551Z pid=63265 tid=1ebt INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> |-----------------+--------+--------+--------+--------+------|
# >> | 種類            | ☗勝率 | ☖勝率 | ☗勝数 | ☖勝数 | 分母 |
# >> |-----------------+--------+--------+--------+--------+------|
# >> | 通常 野良 10分  |  0.498 |  0.502 |    109 |    110 |  219 |
# >> | 通常 野良 3分   |  0.479 |  0.521 |     34 |     37 |   71 |
# >> | 通常 野良 10秒  |  0.576 |  0.424 |     53 |     39 |   92 |
# >> | ｽﾌﾟﾘﾝﾄ 野良 3分 |  0.429 |  0.571 |     39 |     52 |   91 |
# >> |-----------------+--------+--------+--------+--------+------|
