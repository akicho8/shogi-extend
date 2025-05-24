require "./setup"
scope = Swars::Membership.where(id: ::Swars::Membership.last(1000).collect(&:id))
object = QuickScript::Swars::SprintWinRateScript.new({}, { scope: scope })
tp object.aggregate_now
object.cache_write
tp object.rows
# >> 2025-05-24 14:37:06 1/1 100.00 % T1 SprintWinRateScript
# >> |----------------+---|
# >> |  3級/black/win | 3 |
# >> | 五段/black/win | 2 |
# >> | 六段/white/win | 6 |
# >> | 五段/white/win | 1 |
# >> | 16級/white/win | 1 |
# >> | 三段/white/win | 5 |
# >> | 18級/white/win | 2 |
# >> | 19級/white/win | 2 |
# >> |  5級/black/win | 1 |
# >> | 27級/black/win | 1 |
# >> | 20級/black/win | 2 |
# >> |  5級/white/win | 1 |
# >> |  4級/white/win | 3 |
# >> | 17級/white/win | 1 |
# >> |  3級/white/win | 2 |
# >> | 21級/white/win | 1 |
# >> |  2級/white/win | 5 |
# >> | 22級/black/win | 1 |
# >> | 23級/black/win | 1 |
# >> |  4級/black/win | 1 |
# >> | 11級/white/win | 1 |
# >> | 24級/white/win | 1 |
# >> |  1級/white/win | 1 |
# >> |  2級/black/win | 3 |
# >> | 初段/white/win | 3 |
# >> | 初段/black/win | 3 |
# >> | 四段/white/win | 2 |
# >> | 三段/black/win | 2 |
# >> | 11級/black/win | 1 |
# >> | 24級/black/win | 1 |
# >> |  1級/black/win | 1 |
# >> |----------------+---|
# >> 2025-05-24 14:37:06 1/1 100.00 % T1 SprintWinRateScript
# >> 2025-05-24T05:37:06.854Z pid=79240 tid=1qhs INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> |------+--------------------+--------------------+--------+--------+------|
# >> | 棋力 | ☗勝率             | ☖勝率             | ☗勝数 | ☖勝数 | 分母 |
# >> |------+--------------------+--------------------+--------+--------+------|
# >> | 九段 |                    |                    |      0 |      0 |    0 |
# >> | 八段 |                    |                    |      0 |      0 |    0 |
# >> | 七段 |                    |                    |      0 |      0 |    0 |
# >> | 六段 |                0.0 |                1.0 |      0 |      6 |    6 |
# >> | 五段 | 0.6666666666666666 | 0.3333333333333333 |      2 |      1 |    3 |
# >> | 四段 |                0.0 |                1.0 |      0 |      2 |    2 |
# >> | 三段 | 0.2857142857142857 | 0.7142857142857143 |      2 |      5 |    7 |
# >> | 二段 |                    |                    |      0 |      0 |    0 |
# >> | 初段 |                0.5 |                0.5 |      3 |      3 |    6 |
# >> | 1級  |                0.5 |                0.5 |      1 |      1 |    2 |
# >> | 2級  |              0.375 |              0.625 |      3 |      5 |    8 |
# >> | 3級  |                0.6 |                0.4 |      3 |      2 |    5 |
# >> | 4級  |               0.25 |               0.75 |      1 |      3 |    4 |
# >> | 5級  |                0.5 |                0.5 |      1 |      1 |    2 |
# >> | 6級  |                    |                    |      0 |      0 |    0 |
# >> | 7級  |                    |                    |      0 |      0 |    0 |
# >> | 8級  |                    |                    |      0 |      0 |    0 |
# >> | 9級  |                    |                    |      0 |      0 |    0 |
# >> | 10級 |                    |                    |      0 |      0 |    0 |
# >> |------+--------------------+--------------------+--------+--------+------|
