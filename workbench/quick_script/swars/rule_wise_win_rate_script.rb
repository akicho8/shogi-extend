require "./setup"
scope = Swars::Membership.where(id: ::Swars::Membership.last(1000).collect(&:id))
object = QuickScript::Swars::RuleWiseWinRateScript.new({}, { scope: scope })
object.cache_write
tp object.rows
# >> 2025-05-16T00:19:18.029Z pid=7543 tid=42n INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> |-----------------+--------+--------+--------+--------+------|
# >> | 種類            | ☗勝率 | ☖勝率 | ☗勝数 | ☖勝数 | 分母 |
# >> |-----------------+--------+--------+--------+--------+------|
# >> | 通常 野良 10分  |  1.000 |  0.000 |     20 |      0 |   20 |
# >> | 通常 野良 3分   |        |        |      0 |      0 |    0 |
# >> | 通常 野良 10秒  |        |        |      0 |      0 |    0 |
# >> | ｽﾌﾟﾘﾝﾄ 野良 3分 |        |        |      0 |      0 |    0 |
# >> |-----------------+--------+--------+--------+--------+------|
