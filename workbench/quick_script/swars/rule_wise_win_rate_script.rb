require "./setup"
scope = Swars::Membership.where(id: ::Swars::Membership.last(1000).collect(&:id))
object = QuickScript::Swars::RuleWiseWinRateScript.new({}, { scope: scope })
object.cache_write
tp object.rows
# >> 2025-05-24 14:37:34 1/1 100.00 % T1 RuleWiseWinRateScript
# >> 2025-05-24T05:37:34.221Z pid=79441 tid=1r5l INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> |-----------------+--------+--------+--------+--------+------|
# >> | 種類            | ☗勝率 | ☖勝率 | ☗勝数 | ☖勝数 | 分母 |
# >> |-----------------+--------+--------+--------+--------+------|
# >> | 通常 野良 10分  |  0.789 |  0.211 |    239 |     64 |  303 |
# >> | 通常 野良 3分   |  0.476 |  0.524 |     30 |     33 |   63 |
# >> | 通常 野良 10秒  |  0.647 |  0.353 |     44 |     24 |   68 |
# >> | ｽﾌﾟﾘﾝﾄ 野良 3分 |  0.377 |  0.623 |     23 |     38 |   61 |
# >> |-----------------+--------+--------+--------+--------+------|
